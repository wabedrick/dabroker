<?php

namespace App\Http\Controllers\API;

use App\Enums\PropertyStatus;
use App\Http\Controllers\Controller;
use App\Http\Requests\Property\ContactOwnerRequest;
use App\Models\Property;
use App\Models\PropertyInquiry;
use App\Notifications\NewPropertyInquiryNotification;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Log;

class PropertyInquiryController extends Controller
{
    public function store(ContactOwnerRequest $request, Property $property): JsonResponse
    {
        abort_if($property->status !== PropertyStatus::Approved, 422, 'Only approved properties can be contacted.');
        abort_if($property->owner_id === $request->user()->id, 422, 'You cannot contact your own listing.');

        $data = $request->validated();
        $contactMethod = $data['contact_method'] ?? 'app';
        $contactValue = $data['contact_value'] ?? $request->user()->email ?? $request->user()->phone;

        $inquiry = PropertyInquiry::create([
            'property_id' => $property->id,
            'owner_id' => $property->owner_id,
            'sender_id' => $request->user()->id,
            'contact_method' => $contactMethod,
            'contact_value' => $contactValue,
            'message' => $data['message'],
            'metadata' => $data['metadata'] ?? null,
            'status' => PropertyInquiry::STATUS_OPEN,
            'buyer_read_at' => now(),
        ]);

        $inquiry->messages()->create([
            'sender_id' => $request->user()->id,
            'message' => $data['message'],
            'metadata' => $data['metadata'] ?? null,
        ]);

        optional($property->owner)->notify(new NewPropertyInquiryNotification($inquiry));

        Log::info('property_inquiry.submitted', [
            'inquiry_id' => $inquiry->public_id,
            'property_id' => $property->public_id,
            'sender_id' => $request->user()->id,
        ]);

        return response()->json([
            'message' => 'Inquiry sent to property owner.',
            'data' => [
                'inquiry_id' => $inquiry->public_id,
            ],
        ], 201);
    }
}
