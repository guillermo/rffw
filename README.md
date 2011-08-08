RFFW
====

Recive File From Web Server


USAGE
=====

rffw [(--port|-p) 8080] [(-l|--listen) 127.0.0.1]


INTERNALS
=========

* HTML:
  _ There is two forms. One for description, and one for the input file.
  - #input_file_submit.onchange => submit with form[target=hidden_iframe]
  - On load, generate a random uuid, and assign that uuid to the input and
    description.
  - Delay each upload progress check 20 ms after the last one check.
  - There is no index view.
  - There seems to be a bug, that causes google chrome to upload the same file
    twice at the same time.

* Server (Just a mini abstraction of kernel.select and socket)
  - Server: Kernel.select.
  - Client: Kind of overload Socket through delegation.
  - BufferedClient: Overloads Client to add cache in disk the requests.
  - HttpClient: Overloads BufferedClient to understand http connections.

* App
  - AppHandler: Overloads HttpClient, and acts as an app router.
  - (DescriptionHandler | ShowHandler | UploadHandler | UploadStatusHandler | 
    DirHandler: Like http actions. They are modules included in AppHandler.
  - ViewHelpers.
  - data: html/js/css/img
  - Db: Overloads DBM. Used as a backend.
  - Record: Abstraction of Db.
* Parser
  - HttpRequest: StringScanner http request parsers.
  - HttpRespone: Well... not a parser it self, it generate http responses.
  - MimeParser: Process Mime attachments.

USED LIBRARIES
==============

  * Ruby: TempDir
  * Ruby: TCPServer
  * Ruby: TCPClient
  * Ruby: Kernel.select


TEST
====
  * The tests, that not cover the full code, were just used as a tool for 
    helping me to develop the code itself. More were written before the code.



