##Reference Manual
### Elastic Search Model

This module makes it possible to store, retrieve and search data from <a href = "https://www.elastic.co/downloads/elasticsearch">Elasticsearch </a>. It uses the <a href = "github.com/dhavalkapil/elasticsearch-lua">elasticsearch-lua</a> client for Lua. Refer the client <a href="http://elasticsearch-lua.readthedocs.io/en/latest/">here</a> to know the parameters which can be sent through the model functions if any. Return responses are also same as the one offered by this client. 

###Installation and getting started.

To get started, install the elasticsearch-lua rock using
	
	luarocks install --server=http://luarocks.org/dev elasticsearch

Make sure you have elasticsearch installed and running. Refer to the instructions given on the official <a href = "https://www.elastic.co/downloads/elasticsearch">website</a>.

The `es_model.lua` file is the main module. After importing "es_model" we proceed to create a new instance of the model. There should be a file inside models/ which contains the keys and types defined for the particular model. 

	local es_model = require "sailor.es_model"
	-- test.lua should be inside models/ folder.
	local contact = es.model.new("test")

Now, you can assign attributes to `contact` like 
	
	contact.name = "test name"
	contact.email = "test@test.com"

And save it using,

	msg , code = contact.save{id = 1}

The `arg` represented here is named arguments which have to be passed into the function. For list of args that can be passed check the elasticsearch-lua reference.

The return value for these functions is same as elasticsearch-lua. 
Example:

	local msg , err = contact.save{id = 2, routing = "test.com", timout = "2m"}

If the call succeeds then `msg` contains the result table and `err` contains the status code.
If the call fails then `msg` contains `nil` and `err` contains the error message.

###Elasticsearch administration

To use administrative functionalities, 
	
	local es_model = require("sailor.db.es_model")
	-- To use the namespaces
	local res, err = es_model.client.cluster:stats()

Check this <a href="http://elasticsearch-lua.readthedocs.io/en/latest/namespaces/">page</a> for more functions.

###model.save(arg) 

This function takes a list of paramters which would be same as for the elasticsearch-lua client. It saves the attributes assigned to the model if the `body` parameter is not present. Else it just saves the array passsed in the body parameter. The below example saves the `name` attribute into the ES
	
	contact.name = "test"
	contact.save = {id = 1}

The index can be preset in the config file which can also be over written when passing the parameters.

###model.getCount()

This functions returns the number of documents present in the given index and type. You don't need to pass any parameter. 
Example:

	local count = contact.getCount()

###model.getAll()

This function returns a table of all the documents present in the given index and type. No parameter is required. It uses the `client:search()` function from elasticsearch-lua on the inside. 

	local data, err = contact.getAll()

###model.update(arg)

This is used for updating documents already in the index. The id has to be specified.

	contact.update{id = 1, body = {doc = { name = "new name" }}}

###model.delete(arg)

Deletes a particular document with the given id. 

	contact.delete{id = 1}

###model.search(arg)

Search the given index and type. The arg list supports a lot of parameters. Read more about it <a href="https://dhavalkapil.com/elasticsearch-lua/docs/classes/Client.html#Client:search">here.</a> 
	
	contact.search{q = "queryString", size = 15}

###model.get(arg)
	
Get's documents from the database based on the parameters provided. Full list of args can be found <a href="https://dhavalkapil.com/elasticsearch-lua/docs/classes/Client.html#Client:get">here.</a>

	contact.get{id = 1, fields = {name, email}}

###model.bulkIndex(arg)

For indexing multiple documents at once. Uses `client:bulk()`. The index and type have to set in the parameters. For a list of parameters check <a href="https://dhavalkapil.com/elasticsearch-lua/docs/classes/Client.html#Client:bulk">here.</a>

	contact.bulkIndex{
  		body = {
		    -- First action
		    {
		      index = {
		        ["_index"] = "my_index1",
		        ["_type"] = "my_type1"
		      }
		    },
		    -- First body
		    {
		      my_key1 = "my_value1",
		    },
		    -- Second action
		    {
		      index = {
		        ["_index"] = "my_index2",
		        ["_type"] = "my_type2"
		      }
		    },
		    -- Second body
		    {
		      my_key2 = "my_value2",
	    	}
  		}		
	}

###model.mget(arg)

You can get multiple documents in the form of nested table using the `client:mget()`. The allowed parameters are <a href="https://dhavalkapil.com/elasticsearch-lua/docs/classes/Client.html#Client:mget">here.</a>

	contact.mget{
		  body = {
		    docs = {
		      -- First document
		      {
		        ["_index"] = "my_index1",
		        ["_type"] = "my_type1",
		        ["_id"] = "my_id1"
		      },
		      -- Second document
		      {
		        ["_index"] = "my_index2",
		        ["_type"] = "my_type2",
		        ["_id"] = "my_id2"
		      }
		    }
		  }
	}