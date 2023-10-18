#  Peach Scone Market iOS Application
**Updated 10/17/23**

## Software Design
**TODO**

## API Functions
### Check Token
**Parameters** jwt: String
**Return Value** Boolean
Checks if JWT string is a valid token. Returns true if server responds 200 and false if 403. Throws an ApiError otherwise.

**Mobile Status Codes**
-1 : Did not recieve a response from request.

### Send Login
**TODO**

### Send Sign Up
**TODO**

### Send Like
**TODO**

### Load Clothing
**TODO*

### Load Clothing Page
**Parameters**: collectionType: CollectionStruct.CollectionRequestType, pageNumber: Int?, completion:@escaping ([ClothingItem])->()

Loads a clothing page (reference pagination) for clothing collections. Upon request comepletion the clothing is passed into the completion.

**Mobile Status Codes**
-1 : Did not recieve a response from request.
-5 :  Recieved 200 API response but a error was thrown. Most likely JSON Decoding error.


### Load Filter Options
**TODO**

## Views
**TODO**



