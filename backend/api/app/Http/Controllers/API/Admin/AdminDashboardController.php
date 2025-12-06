<?php

namespace App\Http\Controllers\API\Admin;

use App\Enums\PropertyStatus;
use App\Http\Controllers\Controller;
use App\Models\Lodging;
use App\Models\ModerationLog;
use App\Models\Property;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AdminDashboardController extends Controller
{
    public function stats(): JsonResponse
    {
        return response()->json([
            'users' => [
                'total' => User::count(),
                'new_today' => User::whereDate('created_at', today())->count(),
                'brokers' => User::role('professional')->count(),
            ],
            'properties' => [
                'total' => Property::count(),
                'pending' => Property::where('status', PropertyStatus::Pending)->count(),
                'approved' => Property::where('status', PropertyStatus::Approved)->count(),
                'new_today' => Property::whereDate('created_at', today())->count(),
            ],
            'lodgings' => [
                'total' => Lodging::count(),
                'pending' => Lodging::where('status', 'pending')->count(),
                'approved' => Lodging::where('status', 'approved')->count(),
                'new_today' => Lodging::whereDate('created_at', today())->count(),
            ],
        ]);
    }

    public function analytics(Request $request): JsonResponse
    {
        $range = (int) $request->integer('range_days', 30);
        $range = max(7, min($range, 90));

        $end = Carbon::now()->endOfDay();
        $start = (clone $end)->subDays($range - 1)->startOfDay();

        $response = [
            'users' => [
                'daily_new' => $this->buildDateSeries('users', 'created_at', $start, $end),
                'total' => User::count(),
            ],
            'properties' => [
                'daily_new' => $this->buildDateSeries('properties', 'created_at', $start, $end),
                'daily_approved' => $this->buildDateSeries('properties', 'approved_at', $start, $end),
                'pending' => Property::where('status', PropertyStatus::Pending)->count(),
            ],
            'lodgings' => [
                'daily_new' => $this->buildDateSeries('lodgings', 'created_at', $start, $end),
                'daily_approved' => $this->buildDateSeries('lodgings', 'approved_at', $start, $end),
                'pending' => Lodging::where('status', 'pending')->count(),
            ],
            'moderation' => [
                'top_actions' => $this->topModerationActions($start, $end),
            ],
        ];

        return response()->json($response);
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    private function buildDateSeries(string $table, string $column, Carbon $start, Carbon $end): array
    {
        $raw = DB::table($table)
            ->selectRaw('DATE(' . $column . ') as date, COUNT(*) as total')
            ->whereNotNull($column)
            ->whereBetween($column, [$start, $end])
            ->groupByRaw('DATE(' . $column . ')')
            ->pluck('total', 'date')
            ->all();

        $series = [];
        $date = (clone $start);

        while ($date->lte($end)) {
            $key = $date->toDateString();
            $series[] = [
                'date' => $key,
                'count' => (int) ($raw[$key] ?? 0),
            ];
            $date->addDay();
        }

        return $series;
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    private function topModerationActions(Carbon $start, Carbon $end): array
    {
        return ModerationLog::query()
            ->select('action')
            ->selectRaw('COUNT(*) as total')
            ->whereBetween('created_at', [$start, $end])
            ->groupBy('action')
            ->orderByDesc('total')
            ->limit(10)
            ->get()
            ->map(fn($row) => ['action' => $row->action, 'count' => (int) $row->total])
            ->all();
    }
}
