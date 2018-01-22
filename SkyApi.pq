﻿
///////////////////////////////////////////////////////

section SkyApi;

//
// OAuth configuration settings
//
client_id = Text.FromBinary(Extension.Contents("client_id"));
client_secret = Text.FromBinary(Extension.Contents("client_secret"));
api_subscription_key = Text.FromBinary(Extension.Contents("api_subscription_key"));
redirect_uri = "http://localhost/5000";
token_uri = "https://oauth2.sky.blackbaud.com/token";
authorize_uri = "https://oauth2.sky.blackbaud.com/authorization";
logout_uri = "https://login.microsoftonline.com/logout.srf";


// Data Source Kind description
SkyApi = [
    Authentication = [
        OAuth = [
            StartLogin=StartLogin,
            FinishLogin=FinishLogin,
            Refresh=Refresh,
            Logout=Logout
        ]
    ],
    Label = "SkyApi"
];

// Data Source UI publishing description
SkyApi.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { "Blackbaud SkyApi", "Blackbaud SkyApi" },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = SkyApi.Icons,
    SourceTypeImage = SkyApi.Icons
];

SkyApi.Icons = [
    Icon16 = { Extension.Contents("SkyApi16.png"), Extension.Contents("SkyApi20.png"), Extension.Contents("SkyApi24.png"), Extension.Contents("SkyApi32.png") },
    Icon32 = { Extension.Contents("SkyApi32.png"), Extension.Contents("SkyApi40.png"), Extension.Contents("SkyApi48.png"), Extension.Contents("SkyApi64.png") }
];

//
// Implementation
// 

DefaultRequestHeaders = [
    #"bb-api-subscription-key" = api_subscription_key
];

BaseUrl = "https://api.sky.blackbaud.com/";

// Define our top level table types

// Constituent List Endpoint
ConstituentsListType = type table [
    id = text,
    #"type" = text,
    lookup_id = text,
    inactive = logical,
    name = text,
    last = text,
    first = text,
    middle = text,
    preferred_name = text,
    former_name = text,
    suffix = text,
    suffix_2 = text,
    title = text,
    title_2 = text,
    gender = text,
    birthdate = DateType,
    age = number,
    deceased = logical,
    deceased_date = DateType,
    address = AddressType,
    email = EmailType,
    phone = PhoneType,
    online_presence = OnlinePresenceType,
    marital_status = text,
    spouse = record,
    date_added = nullable datetimezone,
    date_modified = nullable datetimezone,
    gives_anonymously = nullable logical
];

// Address List Endpoint
AddressListType = type table [
    id = nullable text,
    constituent_id = nullable text,
    #"type" = nullable text,
    formatted_address = nullable text,
    preferred = nullable logical,
    inactive = nullable logical,
    start = nullable text,
    end = nullable text,
    seasonal_start = SeasonDateType,
    seasonal_end = SeasonDateType,
    do_not_mail = nullable logical,
    address_lines = nullable text,
    city = nullable text,
    suburb = nullable text,
    county = nullable text,
    state = nullable text,
    postal_code = nullable text,    
    country = nullable text,
    date_added = nullable datetimezone,
    date_modified = nullable datetimezone
];

// Phone List Endpoint
PhoneListType = type table [
    id = nullable text,
    constituent_id = nullable text,
    #"type" = nullable text,
    number = nullable text,
    do_not_call = nullable logical,
    primary = nullable logical,
    inactive = nullable logical,
    date_added = nullable datetimezone,
    date_modified = nullable datetimezone
];

// Email List Endpoint
EmailListType = type table [
    id = nullable text,
    constituent_id = nullable text,
    #"type" = nullable text,
    address = nullable text,
    do_not_email = nullable logical,
    primary = nullable logical,
    inactive = nullable logical,
    date_added = nullable datetimezone,
    date_modified = nullable datetimezone
];

// Education List Endpoint
EducationListType = type table [
    id = nullable text,
    constituent_id = nullable text,
    school = nullable text,
    #"type" = nullable text,
    degree = nullable text,
    class_of = nullable text,
    date_entered = DateType,
    date_left = DateType,
    date_graduated = DateType,
    status = nullable text,
    primary = nullable logical,
    majors = {nullable text},
    minors = {nullable text},
    gpa = number,
    campus = nullable text,
    known_name = nullable text,
    social_organization = nullable text,
    class_of_degree = nullable text,
    faculty = nullable text,
    department = nullable text,
    registration_number = nullable text,
    subject_of_study = nullable text,
    date_added = nullable datetimezone,
    date_modified = nullable datetimezone
];

// Constituent Code List Endpoint
ConstituentCodeListType = type table [
    id = nullable text,
    constituent_id = nullable text,
    description = nullable text,
    start = DateType,
    end = DateType,
    inactive = nullable logical,
    date_added = nullable datetimezone,
    date_modified = nullable datetimezone
];

// Online Presence List Endpoint
OnlinePresenceListType = type table [
    id = nullable text,
    constituent_id = nullable text,
    #"type" = nullable text,
    address = nullable text,
    primary = nullable logical,
    inactive = nullable logical,
    date_added = nullable datetimezone,
    date_modified = nullable datetimezone
];

// Relationship List Endpoint
RelationshipListType = type table [
    id = nullable text,
    constituent_id = nullable text,
    relation_id = nullable text,
    name = nullable text,
    #"type" = nullable text,
    start = DateType,
    end = DateType,
    reciprocal_type = nullable text,
    reciprocal_relationship_id = nullable text,
    is_spouse = nullable logical,
    is_organization_contact = nullable logical,
    is_primary_business = nullable logical,
    organization_contact_type = nullable text,
    position = nullable text,
    comment = nullable text,
    date_added = nullable datetimezone,
    date_modified = nullable datetimezone
];

// Constituent Custom Field List Endpoint
ConstituentCustomFielsListType = type table [
    id = nullable text,
    parent_id = nullable text,
    category = nullable text,
    #"type" = nullable text,
    date = nullable datetime,
    comment = nullable text,
    value = nullable text,
    date_added = nullable datetimezone,
    date_modified = nullable datetimezone
];


// ----------------------------------------
// Remaining structured types
DateType = type [
    y = nullable number,
    m = nullable number,
    d = nullable number
];

SeasonDateType = type [
    m = nullable text,
    d = nullable text
];

AddressType = type [
    id = nullable text,
    constituent_id = nullable text,
    #"type" = nullable text,
    formatted_address = nullable text,
    preferred = nullable logical,
    inactive = nullable logical,
    start = nullable text,
    do_not_mail = nullable logical,
    address_lines = nullable text,
    city = nullable text,
    postal_code = nullable text,
    country = nullable text
];

EmailType = type [
    id = nullable text,
    #"type" = nullable text,
    address = nullable text,
    do_not_email = nullable logical,
    primary = nullable logical,
    inactive = nullable logical
];

PhoneType = type [
    id = nullable text,
    constituent_id = nullable text,
    #"type" = nullable text,
    number = nullable text,
    do_not_call = nullable logical,
    primary = nullable logical,
    inactive = nullable logical
];

OnlinePresenceType = type [
    id = nullable text,
    constituent_id = nullable text,
    #"type" = nullable text,
    address = nullable text,
    primary = nullable logical,
    inactive = nullable logical
];

SpouseType = type [
    id = nullable text,
    last = nullable text,
    first = nullable text
];


SchemaTable = #table({"Entity", "Type", "Endpoint"}, {
        {"constituents", ConstituentsListType, "constituent/v1/constituents?"},
        {"phones", PhoneListType, "constituent/v1/phones?"},
        {"emails", EmailListType, "constituent/v1/emailaddresses?"},
        {"addresses", AddressListType, "constituent/v1/addresses?"},
        {"education", EducationListType, "constituent/v1/educations?"},
        {"constituent_codes", ConstituentCodeListType, "constituent/v1/constituents/constituentcodes?"},
        {"online_presence", OnlinePresenceListType, "constituent/v1/onlinepresences?"},
        {"relationships", RelationshipListType, "constituent/v1/relationships?"},
        {"constituent_custom_fields", ConstituentCustomFielsListType, "constituent/v1/constituents/customfields?"}
});
        
GetSchemaForEntity = (entity as text) as type => try SchemaTable{[Entity=entity]}[Type] otherwise error "Couldn't find entity: '" & entity &"'";

[DataSource.Kind="SkyApi", Publish="SkyApi.Publish"]
shared SkyApi.Contents = () => SkyApiNavTable(BaseUrl) as table;

SkyApiNavTable = (url as text) as table =>
    let
        // Use our schema table as the source of top level items in the navigation tree
        entities = Table.SelectColumns(SchemaTable, {"Entity", "Endpoint"}),
        rename = Table.RenameColumns(entities, {{"Entity", "Name"}}),
        // Add Data as a calculated column
        withData = Table.AddColumn(rename, "Data", each GetEntity(Uri.Combine(url, [Endpoint]),[Name]), type table),
        // Add ItemKind and ItemName as fixed text values
        withItemKind = Table.AddColumn(withData, "ItemKind", each "Table", type text),
        withItemName = Table.AddColumn(withItemKind, "ItemName", each "Table", type text),
        // Indicate that the node should not be expandable
        withIsLeaf = Table.AddColumn(withItemName, "IsLeaf", each true, type logical),
        // Generate the nav table
        navTable = Table.ToNavigationTable(withIsLeaf, {"Name"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
    in
        navTable;

SkyApi.Feed = (url as text, optional schema as type) as table => GetAllPagesByNextLink(url, schema);

GetEntity = (url as text, entity as text) as table => 
    let
        fullUrl = url,
        schema = GetSchemaForEntity(entity),
        result = SkyApi.Feed(fullUrl, schema),
        appliedSchema = Table.ChangeType(result, schema)
    in
        appliedSchema;


GetPage = (url as text, optional schema as type) as table =>
    let
        response = Web.Contents(url, [ Headers = DefaultRequestHeaders ]),        
        body = Json.Document(response),
        nextLink = GetNextLink(body),
        
        // If we have no schema, use Table.FromRecords() instead
        // (and hope that our results all have the same fields).
        // If we have a schema, expand the record using its field names
        data =
            //if (schema <> null) then // error in Microsoft tutorial?
            if (schema = null) then
                Table.FromRecords(body[value])
            else
                let
                    // convert the list of records into a table (single column of records)
                    asTable = Table.FromList(body[value], Splitter.SplitByNothing(), {"Column1"}),
                    fields = Record.FieldNames(Type.RecordFields(Type.TableRow(schema))),
                    //expanded = Table.ExpandRecordColumn(asTable, fields)
                    expanded = Table.ExpandRecordColumn(asTable, "Column1",fields)
                in
                    expanded
    in
        data meta [NextLink = nextLink];

// Read all pages of data.
// After every page, we check the "NextLink" record on the metadata of the previous request.
// Table.GenerateByPage will keep asking for more pages until we return null.
GetAllPagesByNextLink = (url as text, optional schema as type) as table =>
    Table.GenerateByPage((previous) => 
        let
            // if previous is null, then this is our first page of data
            nextLink = if (previous = null) then url else Value.Metadata(previous)[NextLink]?,
            // if NextLink was set to null by the previous call, we know we have no more data
            page = if (nextLink <> null) then GetPage(nextLink, schema) else null
        in
            page
    );

// In this implementation, 'response' will be the parsed body of the response after the call to Json.Document.
// We look for the 'next_link' field and simply return null if it doesn't exist.
GetNextLink = (response) as nullable text => Record.FieldOrDefault(response, "next_link");

// 
// Load common library functions
// 
// TEMPORARY WORKAROUND until we're able to reference other M modules
Extension.LoadFunction = (name as text) =>
    let
        binary = Extension.Contents(name),
        asText = Text.FromBinary(binary)
    in
        Expression.Evaluate(asText, #shared);

Table.ChangeType = Extension.LoadFunction("Table.ChangeType.pqm");
Table.GenerateByPage = Extension.LoadFunction("Table.GenerateByPage.pqm");
Table.ToNavigationTable = Extension.LoadFunction("Table.ToNavigationTable.pqm");



//
// OAuth implementation
//
// See the following links for more details on AAD/Graph OAuth:
// * https://docs.microsoft.com/en-us/azure/active-directory/active-directory-protocols-oauth-code 
// * https://graph.microsoft.io/en-us/docs/authorization/app_authorization
//
// StartLogin builds a record containing the information needed for the client
// to initiate an OAuth flow. Note for the AAD flow, the display parameter is
// not used.
//
// resourceUrl: Derived from the required arguments to the data source function
//              and is used when the OAuth flow requires a specific resource to 
//              be passed in, or the authorization URL is calculated (i.e. when
//              the tenant name/ID is included in the URL). In this example, we
//              are hardcoding the use of the "common" tenant, as specified by
//              the 'authorize_uri' variable.
// state:       Client state value we pass through to the service.
// display:     Used by certain OAuth services to display information to the
//              user.
//
// Returns a record containing the following fields:
// LoginUri:     The full URI to use to initiate the OAuth flow dialog.
// CallbackUri:  The return_uri value. The client will consider the OAuth
//               flow complete when it receives a redirect to this URI. This
//               generally needs to match the return_uri value that was
//               registered for your application/client. 
// WindowHeight: Suggested OAuth window height (in pixels).
// WindowWidth:  Suggested OAuth window width (in pixels).
// Context:      Optional context value that will be passed in to the FinishLogin
//               function once the redirect_uri is reached. 
//
	
StartLogin = (resourceUrl, state, display) =>
	let
		authorizeUrl = authorize_uri & "?" & Uri.BuildQueryString([
			client_id = client_id,  
			redirect_uri = redirect_uri,
			response_type = "code",
			state = state

		])
	in
		[
			LoginUri = authorizeUrl,
			CallbackUri = redirect_uri,
			WindowHeight = 720,
			WindowWidth = 1024,
			Context = null
		];

// FinishLogin is called when the OAuth flow reaches the specified redirect_uri. 
// Note for the AAD flow, the context and state parameters are not used. 
//
// context:     The value of the Context field returned by StartLogin. Use this to 
//              pass along information derived during the StartLogin call (such as
//              tenant ID)
// callbackUri: The callbackUri containing the authorization_code from the service.
// state:       State information that was specified during the call to StartLogin. 
FinishLogin = (context, callbackUri, state) =>
	let
		// parse the full callbackUri, and extract the Query string
		parts = Uri.Parts(callbackUri)[Query],
		// if the query string contains an "error" field, raise an error
		// otherwise call TokenMethod to exchange our code for an access_token
		result = if (Record.HasFields(parts, {"error", "error_description"})) then 
					error Error.Record(parts[error], parts[error_description], parts)
					else
					TokenMethod("authorization_code", "code", parts[code])
	in
		result;

// Called when the access_token has expired, and a refresh_token is available.
// 
Refresh = (resourceUrl, refresh_token) => TokenMethod("refresh_token", "refresh_token", refresh_token);

Logout = (token) => logout_uri;


// grantType:  Maps to the "grant_type" query parameter.
// tokenField: The name of the query parameter to pass in the code.
// code:       Is the actual code (authorization_code or refresh_token) to send to the service.
TokenMethod = (grantType, tokenField, code) =>
	let
		queryString = [
			client_id = client_id,
			grant_type = grantType,
			redirect_uri = redirect_uri,
			client_secret = client_secret
		],
		queryWithCode = Record.AddField(queryString, tokenField, code),

		tokenResponse = Web.Contents(token_uri, [
			Content = Text.ToBinary(Uri.BuildQueryString(queryWithCode)),
			Headers = [
				#"Content-type" = "application/x-www-form-urlencoded",
				#"Accept" = "application/json"
			],
			ManualStatusHandling = {400} 
		]),
		body = Json.Document(tokenResponse),
		result = if (Record.HasFields(body, {"error", "error_description"})) then 
					error Error.Record(body[error], body[error_description], body)
					else
					body
	in
		result;