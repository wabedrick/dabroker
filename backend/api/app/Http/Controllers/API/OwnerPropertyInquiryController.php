<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Resources\PropertyInquiryResource;
use App\Models\PropertyInquiry;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class OwnerPropertyInquiryController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $user = $request->user();

        $query = PropertyInquiry::query()
            ->with(['property:id,public_id,title,status', 'sender:id,name,preferred_role'])
            ->where('owner_id', $user->id)
            ->latest();

        if ($status = $request->string('status')->toString()) {
            $query->where('status', $status);
        }

        if ($propertyId = $request->string('property_id')->toString()) {
            $query->whereHas('property', fn($builder) => $builder->where('public_id', $propertyId));
        }

        if ($request->boolean('unread_only')) {
            $query->whereNull('read_at');
        }

        $inquiries = $query->paginate((int) $request->integer('per_page', 15));

        return PropertyInquiryResource::collection($inquiries);
    }

    public function show(Request $request, PropertyInquiry $inquiry): PropertyInquiryResource
    {
        $this->authorizeInquiry($request->user()->id, $inquiry);

        if (is_null($inquiry->read_at)) {
            $inquiry->forceFill(['read_at' => now()])->save();
        }

        return PropertyInquiryResource::make(
            $inquiry->loadMissing([
                'property:id,public_id,title,status',
                'sender:id,name,preferred_role',
                'messages',
            ])
        );
    }

    private function authorizeInquiry(int $ownerId, PropertyInquiry $inquiry): void
    {
        abort_if($inquiry->owner_id !== $ownerId, 403, 'You do not have access to this inquiry.');
    }
}
