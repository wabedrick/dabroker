<?php

namespace App\Http\Controllers\API\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\ModerationLogResource;
use App\Models\ModerationLog;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class AdminModerationLogController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $perPage = (int) $request->integer('per_page', 25);
        $perPage = max(1, min($perPage, 100));

        $query = ModerationLog::query()
            ->with(['performedBy']);

        if ($types = $this->parseArrayInput($request->query('entity_type'))) {
            $classMap = collect($types)->map(function (string $type): string {
                return match (strtolower($type)) {
                    'property', 'properties' => \App\Models\Property::class,
                    'lodging', 'lodgings' => \App\Models\Lodging::class,
                    'user', 'users' => \App\Models\User::class,
                    default => $type,
                };
            })->all();
            $query->whereIn('moderatable_type', $classMap);
        }

        if ($entityId = $request->query('entity_id')) {
            $query->where('moderatable_id', $entityId);
        }

        if ($publicId = $request->query('entity_public_id')) {
            $query->where('moderatable_public_id', $publicId);
        }

        if ($actions = $this->parseArrayInput($request->query('action'))) {
            $query->whereIn('action', $actions);
        }

        if ($performedBy = $request->query('performed_by')) {
            $query->where('performed_by', $performedBy);
        }

        if ($request->filled('date_from')) {
            $query->whereDate('created_at', '>=', $request->date('date_from'));
        }

        if ($request->filled('date_to')) {
            $query->whereDate('created_at', '<=', $request->date('date_to'));
        }

        $query->latest('created_at');

        $paginator = $query->paginate($perPage)->appends($request->query());

        return ModerationLogResource::collection($paginator);
    }

    /**
     * @return array<int, string>
     */
    private function parseArrayInput(mixed $value): array
    {
        if ($value === null) {
            return [];
        }

        if (is_array($value)) {
            return array_values(array_filter(array_map('strval', $value)));
        }

        return array_values(array_filter(array_map('trim', explode(',', (string) $value))));
    }
}
