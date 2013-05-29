/*
 * HTTPbis P1
 *
 * http://tools.ietf.org/html/draft-ietf-httpbis-p1-messaging
 *
 * <uri_host> element has been renamed to <hostname> as a dirty workaround for
 * element being re-defined with another meaning in RFC/3986_uri
 *
 * @append RFC/3986_uri.pegjs
 * @append RFC/5324_abnf.pegjs
 */

/* 2.6.  Protocol Versioning */
HTTP_version
  = HTTP_name "/" [0-9] "." [0-9]

HTTP_name
  = "\x48\x54\x54\x50"


/* 2.7.  Uniform Resource Identifiers */
absolute_path
  = ("/" segment)+

partial_URI
  = relative_part ("?" query)?

http_URI
  = "http:" "//" authority path_abempty ("?" query)?

https_URI
  = "https:" "//" authority path_abempty ("?" query)?


/* 3.  Message Format */
HTTP_message
  = start_line
    (header_field CRLF)*
    CRLF
    message_body?


/* 3.1.  Start Line */
start_line
  = request_line
  / status_line


/* 3.1.1.  Request Line */
request_line
  = method SP request_target SP HTTP_version CRLF

method
  = token


/* 3.1.2.  Status Line */
status_line
  = HTTP_version SP status_code SP reason_phrase CRLF

status_code
  = $(DIGIT DIGIT DIGIT)

reason_phrase
  = $( HTAB
     / SP
     / VCHAR
     / obs_text
     )*


/* 3.2.  Header Fields */
header_field
  = field_name ":" OWS field_value BWS

field_name
  = token

field_value
  = (field_content / obs_fold)*

field_content
  = $( HTAB
     / SP
     / VCHAR
     / obs_text
     )*

obs_fold
  // obsolete line folding
  = $(CRLF (SP / HTAB))


/* 3.2.3.  Whitespace */
OWS
  // optional whitespace
  = $( SP
     / HTAB
     )*

RWS
  // required whitespace
  = $( SP
     / HTAB
     )+

BWS
  // "bad" whitespace
  = OWS


/* 3.2.6.  Field value components */
word
  = token
  / quoted_string

token
  = $(tchar+)

tchar
  // any VCHAR, except special
  = "!"
  / "#"
  / "$"
  / "%"
  / "&"
  / "'"
  / "*"
  / "+"
  / "-"
  / "."
  / "^"
  / "_"
  / "`"
  / "|"
  / "~"
  / DIGIT
  / ALPHA

special
  = "("
  / ")"
  / "<"
  / ">"
  / "@"
  / ","
  / ";"
  / ":"
  / "\\"
  / DQUOTE
  / "/"
  / "["
  / "]"
  / "?"
  / "="
  / "{"
  / "}"

quoted_string
  = DQUOTE $(qdtext / quoted_pair)* DQUOTE

qdtext
  = HTAB
  / SP
  / "\x21"
  / [\x23-\x5B]
  / [\x5D-\x7E]
  / obs_text

obs_text
  = [\x80-\xFF]

quoted_pair
  = "\\" (HTAB / SP / VCHAR / obs_text)

comment
  = "(" $(ctext / quoted_cpair / comment)* ")"

ctext
  = HTAB
  / SP
  / [\x21-\x27]
  / [\x2A-\x5B]
  / [\x5D-\x7E]
  / obs_text

quoted_cpair
  = "\\" (HTAB / SP / VCHAR / obs_text)


/* 3.3.  Message Body */
message_body
  = $(OCTET*)


/* 3.3.1.  Transfer-Encoding */
transfer_encoding
  = ("," OWS)* transfer_coding (OWS "," (OWS transfer_coding)?)*


/* 3.3.2.  Content-Length */
content_length
  = $(DIGIT+)


/* 4.  Transfer Codings */
transfer_coding
  = "chunked"i
  / "compress"i
  / "deflate"i
  / "gzip"i
  / transfer_extension

transfer_extension
  = token (OWS ";" OWS transfer_parameter)*

transfer_parameter
  = attribute BWS "=" BWS value

attribute
  = token

value
  = word


/* 4.1.  Chunked Transfer Coding */
// FIXME


/* 4.1.1.  Trailer */
// FIXME


/* 4.2.  Compression Codings */
// FIXME


/* 4.3.  TE */
// FIXME


/* 5.3.  Request Target */
request_target
  = origin_form
  / absolute_form
  / authority_form
  / asterisk_form

origin_form
  = absolute_path ("?" query)?

absolute_form
  = absolute_URI

authority_form
  = authority

asterisk_form
  = "*"


/* 5.4.  Host */
host
  = hostname (":" port)?


/* 5.7.1.  Via */
// FIXME


/* 6.1.  Connection */
// FIXME


/* 6.7.  Upgrade */
// FIXME


/* Appendix B.  ABNF list extension: #rule */
/*
In ABNF
1#element => element *( OWS "," OWS element )
#element => [ 1#element ]
<n>#<m>element => element <n-1>*<m-1>( OWS "," OWS element )

Accept empty elements
#element => [ ( "," / element ) *( OWS "," [ OWS element ] ) ]
1#element => *( "," OWS ) element *( OWS "," [ OWS element ] )

In PEGjs
#element => (("," / element) (OWS "," (OWS element)?)*)?
1#element => ("," OWS)* element (OWS "," (OWS element)?)*
*/
