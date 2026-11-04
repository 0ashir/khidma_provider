Structured log of API additions / behavior changes. Top-level grouped by app  
 audience.

Contents:

1. Provider App  
   1. Login — handyman user type  
   2. Get handymen  
   3. Store handyman  
   4. Update handyman  
   5. Delete handyman  
   6. Toggle handyman status  
   7. Toggle handyman availability

### **1.1 Login — handyman user type**

**Endpoint:** `POST partner/api/v1/login`  
 **Controller:** `app/Controllers/Apis/Provider/AuthApiController.php::loginHandyman()`

The existing provider login endpoint now branches on the `user_type` field. When  
 `user_type=handyman` is sent, the request is handled by `loginHandyman()` instead  
 of the standard provider flow. No new route was added — it is a dispatch within  
 the same endpoint.

#### **What changed**

Previously `POST partner/api/v1/login` only supported provider (group\_id \= 3\)  
 logins. Sending `user_type=handyman` now authenticates against group\_id \= 4  
 (handyman) users and returns handyman-specific profile data.

#### **Request parameters**

| Parameter | Type | Required | Notes |
| ----- | ----- | ----- | ----- |
| `user_type` | string | Yes | Must be `"handyman"` to trigger this branch |
| `mobile` | string | Yes | Phone number (digits only) |
| `country_code` | string | No | e.g. `+91`. When provided, scoped to exact match |
| `password` | string | Yes |  |
| `fcm_id` | string | No | Firebase token; stored/updated on login |
| `platform` | string | No | `android` / `ios` / `web` |
| `language_code` | string | No | Passed to FCM store for notification language preference |

**Notes:**

* Handyman login is **phone-only**. Email login is not supported for this user type.  
* `country_code` is optional but recommended. When omitted, the first handyman  
   matching the phone number is returned (risk of collision in multi-country setups).  
* Login attempt throttling applies (same IonAuth mechanism as provider login).  
* A JWT is generated directly (not via `generate_tokens()`) because handyman rows  
   do not have `loginType` set — standard token generation would fail the lookup.  
* The returned token must be passed as `Authorization: Bearer <token>` on all  
   subsequent handyman API calls.

#### **Response (success)**

{  
  "error": false,  
  "token": "\<jwt\>",  
  "message": "User Logged successfully",  
  "data": {  
    "id": 42,  
    "username": "John Doe",  
    "email": "john@example.com",  
    "phone": "9876543210",  
    "country\_code": "+91",  
    "image": "https://example.com/storage/profile/abc.jpg",  
    "fcm\_id": "fcm-token-here",  
    "partner\_id": 10,  
    "ratings": "4.5",  
    "number\_of\_ratings": "12",  
    "is\_available": 1,  
    "address": "123 Main St"  
  }  
}

#### **Response (error — wrong credentials)**

{  
  "error": true,  
  "message": "Incorrect login credentials. Please check and try again."  
}

#### **Response (error — inactive account)**

{  
  "error": true,  
  "message": "Account is inactive"  
}

---

### **1.2 Get handymen**

**Controller:** `app/Controllers/Apis/Provider/HandymanApiController.php`

**Endpoint:** `POST partner/api/v1/get_handymen`

Returns a paginated list of handymen belonging to the authenticated provider,  
 each with their custom field values attached.

#### **Request parameters**

| Parameter | Type | Required | Default | Notes |
| ----- | ----- | ----- | ----- | ----- |
| `limit` | int | No | `10` | Page size |
| `offset` | int | No | `0` | Pagination offset |
| `search` | string | No | `""` | Matches username / phone / email |

#### **Response**

{  
  "error": false,  
  "message": "Data retrieved successfully",  
  "total": 2,  
  "data": \[  
    {  
      "id": 42,  
      "username": "John Doe",  
      "phone": "9876543210",  
      "country\_code": "+91",  
      "email": "john@example.com",  
      "image": "https://example.com/storage/profile/abc.jpg",  
      "active": 1,  
      "is\_available": 1,  
      "address": "123 Main St",  
      "custom\_fields": \[  
        {  
          "id": 1,  
          "field\_label": "License Number",  
          "field\_type": "text",  
          "value": "LIC-12345"  
        },  
        {  
          "id": 2,  
          "field\_label": "Certificate",  
          "field\_type": "file",  
          "value": "https://example.com/storage/custom\_fields/cert.pdf"  
        }  
      \],  
      "translations": \[  
        {  
          "language\_id": 1,  
          "language\_code": "en",  
          "username": "John Doe"  
        },  
        {  
          "language\_id": 2,  
          "language\_code": "fr",  
          "username": null  
        }  
      \]  
    }  
  \]  
}

**Notes:**

* `custom_fields` is `null` when no values exist for the handyman.  
* `value` for `file`\-type fields is resolved to a full URL. `null` if the file  
   no longer exists on storage.  
* Only custom fields with `field_group = handyman_details` and `visible = 1`  
   are included.  
* `translations` always contains one entry per configured language. `username`  
   is `null` for languages that have no saved translation.

---

### **1.3 Store handyman**

**Endpoint:** `POST partner/api/v1/store_handyman`

Creates a new handyman and assigns them to the authenticated provider.

#### **Request parameters (multipart/form-data)**

| Parameter | Type | Required | Notes |
| ----- | ----- | ----- | ----- |
| `username` | string | Yes | Plain string **or** `username[en]`, `username[fr]` etc. for multilang |
| `phone` | string | Yes |  |
| `country_code` | string | Yes | e.g. `+91` |
| `password` | string | Yes | Validated against active password strength rules |
| `profile_image` | file | Yes | Uploaded to `profile` storage folder |
| `email` | string | No | Validated for format and uniqueness |
| `address` | string | No |  |
| `status` | int | No | `1` (active) or `0` (inactive). Defaults to `1` |
| `cf_<id>` | mixed | Depends | Custom field value keyed by field ID (e.g. `cf_3`). File fields accept file uploads |

#### **Response (success)**

{  
  "error": false,  
  "message": "Data saved successfully"  
}

#### **Response (error)**

{  
  "error": true,  
  "message": "Phone number already registered"  
}

**Notes:**

* `username` supports multilang input: send `username[en]=John&username[fr]=Jean`.  
   The default-language value is required; other languages are optional.  
* A flat `username` string is also accepted and mapped to the default language.  
* Phone \+ country code uniqueness is enforced across all users.  
* Password strength rules (min length, uppercase, number, special char) are  
   applied server-side per the admin-configured rules.  
* Handyman is assigned to `users_groups.group_id = 4`.

---

### **1.4 Update handyman**

**Endpoint:** `POST partner/api/v1/update_handyman`

Updates an existing handyman. Only handymen owned by the authenticated provider  
 can be updated.

#### **Request parameters (multipart/form-data)**

| Parameter | Type | Required | Notes |
| ----- | ----- | ----- | ----- |
| `handyman_id` | int | Yes | ID of the handyman to update |
| `username` | string | Yes | Same multilang rules as `store_handyman` |
| `phone` | string | Yes |  |
| `country_code` | string | Yes |  |
| `email` | string | No |  |
| `address` | string | No |  |
| `status` | int | No | `1` or `0` |
| `profile_image` | file | No | If omitted, existing image is kept |
| `cf_<id>` | mixed | Depends | Custom field values; file fields only update when a new file is sent |

#### **Response (success)**

{  
  "error": false,  
  "message": "Data updated successfully"  
}

**Notes:**

* Password cannot be changed via this endpoint.  
* Old profile image is deleted from storage after a successful update only when  
   a new image is uploaded.

---

### **1.5 Delete handyman**

**Endpoint:** `POST partner/api/v1/delete_handyman`

Soft-deletes the handyman record and their associated data, then removes the  
 profile image from storage.

#### **Request parameters**

| Parameter | Type | Required | Notes |
| ----- | ----- | ----- | ----- |
| `handyman_id` | int | Yes | Must belong to authenticated provider |

#### **Response (success)**

{  
  "error": false,  
  "message": "Data deleted successfully"  
}

**Notes:**

* Soft-deletes rows in: `handyman_details`, `translated_handyman_details`,  
   `handyman_custom_field_values`, `users`.  
* All deletes are wrapped in a single DB transaction.

---

### **1.6 Toggle handyman status**

**Endpoint:** `POST partner/api/v1/toggle_handyman_status`

Toggles the `active` flag (1 → 0 or 0 → 1\) for the given handyman.

#### **Request parameters**

| Parameter | Type | Required | Notes |
| ----- | ----- | ----- | ----- |
| `handyman_id` | int | Yes | Must belong to authenticated provider |

#### **Response (success)**

{  
  "error": false,  
  "message": "Activated successfully",  
  "data": {  
    "active": 1  
  }  
}

---

### **1.7 Toggle handyman availability**

**Endpoint:** `POST partner/api/v1/toggle_handyman_availability`

Toggles the `is_available` flag (1 → 0 or 0 → 1\) in `handyman_details`.

#### **Request parameters**

| Parameter | Type | Required | Notes |
| ----- | ----- | ----- | ----- |
| `handyman_id` | int | Yes | Must belong to authenticated provider |

#### **Response (success)**

{  
  "error": false,  
  "message": "Marked as available",  
  "data": {  
    "is\_available": 1  
  }  
}  
