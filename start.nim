import std/httpclient
import std/json


var defaultSpeed {.used.} :float = 10.55

type Animal = enum
  Cat, Dog

type AttrAnimal = ref object of RootObj
  TypeOfAnimal: Animal
  Speed: float

var pitbul: AttrAnimal  = AttrAnimal(TypeOfAnimal: Animal.Dog, Speed: 24.55)

var hdrs = [
  ("cache-control", "must-revalidate"),
  ("x-animal", $(pitbul.TypeOfAnimal)),
  ("x-animal-speed", $(pitbul.Speed))
]

var c = newHttpClient()
var headers = newHttpHeaders(hdrs)

c.timeout = 5000
c.headers = headers

proc sendPayload(client: HttpClient, msg: string = ""): JsonNode  =
  try:
    client.headers.add("x-msg", msg)
    var content = client.getContent("https://httpbin.org/headers")
    result = parseJson(content)
    return
  except CatchableError:
    var err = getCurrentException() 
    echo err.msg
    system.quit(-1)
    
var data = c.sendPayload("Hello World")["headers"]

echo "HTTPBIN - Headers Data" & " "  & $(len(data)) & "\n"
for k,v in pairs(data):
  echo $(k) & " >>> " & $(v)

