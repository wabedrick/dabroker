<?php

namespace App\Http\Controllers\API;

use App\Enums\PropertyStatus;
use App\Http\Controllers\Controller;
use App\Http\Requests\Property\RejectPropertyRequest;
use App\Http\Resources\PropertyResource;
use App\Models\ModerationLog;
use App\Models\Property;
use Illuminate\Support\Facades\Auth;

class PropertyApprovalController extends Controller
{
    public function approve(Property $property): PropertyResource
    {
        $this->authorize('approve', Property::class);

        $previousStatus = $property->status;

        $property->forceFill([
            'status' => PropertyStatus::Approved,
            'approved_at' => now(),
            'approved_by' => Auth::id(),
            'rejection_reason' => null,
            'published_at' => $property->published_at ?? now(),
        ])->save();

        $this->logModeration(
            $property,
            'property_approved',
            null,
            ['status' => $previousStatus?->value],
            ['status' => PropertyStatus::Approved->value],
        );

        return new PropertyResource($property->fresh(['owner', 'approver']));
    }

    public function reject(RejectPropertyRequest $request, Property $property): PropertyResource
    {
        $this->authorize('approve', Property::class);

        $previousStatus = $property->status;

        $property->forceFill([
            'status' => PropertyStatus::Rejected,
            'approved_at' => null,
            'approved_by' => Auth::id(),
            'rejection_reason' => $request->validated()['reason'],
        ])->save();

        $this->logModeration(
            $property,
            'property_rejected',
            $request->validated()['reason'],
            ['status' => $previousStatus?->value],
            ['status' => PropertyStatus::Rejected->value],
        );

        return new PropertyResource($property->fresh(['owner', 'approver']));
    }

    private function logModeration(
        Property $property,
        string $action,
        ?string $reason,
        array $oldValues,
        array $newValues
    ): void {
        ModerationLog::create([
            'moderatable_type' => Property::class,
            'moderatable_id' => $property->id,
            'moderatable_public_id' => $property->public_id,
            'performed_by' => Auth::id(),
            'action' => $action,
            'previous_status' => $oldValues['status'] ?? null,
            'new_status' => $newValues['status'] ?? null,
            'reason' => $reason,
            'old_values' => $oldValues,
            'new_values' => $newValues,
        ]);
    }
}
