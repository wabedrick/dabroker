<?php

namespace App\Http\Controllers\API\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\LodgingResource;
use App\Models\Lodging;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class AdminLodgingController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $perPage = (int) $request->integer('per_page', 20);
        $perPage = max(1, min($perPage, 100));

        $query = Lodging::query()
            ->with([
                'host.roles',
                'host.permissions',
                'approver.roles',
                'approver.permissions',
            ])
            ->when($request->boolean('with_trashed'), fn(Builder $builder): Builder => $builder->withTrashed());

        if ($statuses = $this->parseArrayInput($request->input('status'))) {
            $query->whereIn('status', $statuses);
        }

        if ($types = $this->parseArrayInput($request->input('type'))) {
            $query->whereIn('type', $types);
        }

        if ($hostId = $request->integer('host_id')) {
            $query->where('host_id', $hostId);
        }

        if ($request->filled('search')) {
            $search = (string) $request->input('search');
            $query->where(function (Builder $builder) use ($search): void {
                $builder
                    ->where('title', 'like', "%{$search}%")
                    ->orWhere('city', 'like', "%{$search}%")
                    ->orWhere('state', 'like', "%{$search}%")
                    ->orWhere('country', 'like', "%{$search}%")
                    ->orWhereHas('host', function (Builder $hostQuery) use ($search): void {
                        $hostQuery->where('name', 'like', "%{$search}%")
                            ->orWhere('email', 'like', "%{$search}%");
                    });
            });
        }

        if ($request->filled('created_from')) {
            $query->whereDate('created_at', '>=', $request->date('created_from'));
        }

        if ($request->filled('created_to')) {
            $query->whereDate('created_at', '<=', $request->date('created_to'));
        }

        $sort = $request->input('sort', 'recent');
        match ($sort) {
            'price_asc' => $query->orderBy('price_per_night', 'asc'),
            'price_desc' => $query->orderBy('price_per_night', 'desc'),
            'oldest' => $query->orderBy('created_at', 'asc'),
            default => $query->latest('created_at'),
        };

        $paginator = $query->paginate($perPage)->appends($request->query());

        return LodgingResource::collection($paginator);
    }

    public function show(Request $request, Lodging $lodging): LodgingResource
    {
        $lodging->loadMissing([
            'host.roles',
            'host.permissions',
            'approver.roles',
            'approver.permissions',
            'media',
            'availability',
        ]);

        return new LodgingResource($lodging);
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
