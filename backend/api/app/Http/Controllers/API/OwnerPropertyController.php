<?php

namespace App\Http\Controllers\API;

use App\Enums\PropertyStatus;
use App\Http\Controllers\Controller;
use App\Http\Requests\Property\StorePropertyRequest;
use App\Http\Requests\Property\UpdatePropertyRequest;
use App\Http\Resources\PropertyResource;
use App\Models\Property;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class OwnerPropertyController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = $request->user()
            ->properties()
            ->latest();

        if ($request->filled('status')) {
            $status = PropertyStatus::tryFrom((string) $request->query('status'));

            if ($status) {
                $query->where('status', $status->value);
            }
        }

        return PropertyResource::collection($query->paginate());
    }

    public function store(StorePropertyRequest $request): JsonResponse
    {
        $this->authorize('create', Property::class);

        $data = $request->validated();

        $property = $request->user()->properties()->create([
            ...$data,
            'status' => PropertyStatus::Pending,
            'approved_by' => null,
            'approved_at' => null,
            'rejection_reason' => null,
        ]);

        return (new PropertyResource($property->fresh('owner')))
            ->response()
            ->setStatusCode(201);
    }

    public function update(UpdatePropertyRequest $request, Property $property): PropertyResource
    {
        $this->authorize('update', $property);

        $property->fill($request->validated());
        $property->save();

        return new PropertyResource($property->fresh('owner'));
    }

    public function destroy(Request $request, Property $property): JsonResponse
    {
        $this->authorize('delete', $property);

        $property->delete();

        return response()->json([
            'message' => 'Property deleted successfully.',
        ]);
    }
}
