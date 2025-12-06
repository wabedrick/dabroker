<?php

namespace App\Http\Controllers\API\Admin;

use App\Enums\PropertyStatus;
use App\Http\Controllers\Controller;
use App\Http\Resources\PropertyResource;
use App\Models\Property;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class AdminPropertyController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $perPage = (int) $request->integer('per_page', 20);
        $perPage = max(1, min($perPage, 100));

        $query = Property::query()
            ->with([
                'owner:id,name,email,preferred_role',
                'approver:id,name,email,preferred_role',
            ])
            ->withCount(['inquiries'])
            ->when($request->boolean('with_trashed'), fn(Builder $builder): Builder => $builder->withTrashed());

        if ($statuses = $this->parseArrayInput($request->input('status'))) {
            $query->whereIn('status', $statuses);
        }

        if ($types = $this->parseArrayInput($request->input('type'))) {
            $query->whereIn('type', $types);
        }

        if ($ownerId = $request->integer('owner_id')) {
            $query->where('owner_id', $ownerId);
        }

        if ($request->filled('search')) {
            $search = (string) $request->input('search');
            $query->where(function (Builder $builder) use ($search): void {
                $builder
                    ->where('title', 'like', "%{$search}%")
                    ->orWhere('city', 'like', "%{$search}%")
                    ->orWhere('state', 'like', "%{$search}%")
                    ->orWhere('country', 'like', "%{$search}%")
                    ->orWhereHas('owner', function (Builder $ownerQuery) use ($search): void {
                        $ownerQuery->where('name', 'like', "%{$search}%")
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
            'price_asc' => $query->orderBy('price', 'asc'),
            'price_desc' => $query->orderBy('price', 'desc'),
            'oldest' => $query->orderBy('created_at', 'asc'),
            'pending_first' => $query->orderByRaw("status = ? desc", [PropertyStatus::Pending->value])
                ->latest('created_at'),
            default => $query->latest('created_at'),
        };

        $paginator = $query->paginate($perPage)->appends($request->query());

        return PropertyResource::collection($paginator);
    }

    public function show(Request $request, Property $property): PropertyResource
    {
        $property->loadMissing([
            'owner:id,name,email,preferred_role',
            'approver:id,name,email,preferred_role',
            'media',
            'inquiries',
        ]);

        return new PropertyResource($property);
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
