-------------------------------------------------------------------------------------------
-- elasticsearch.lua: DB module for connecting, querying and serching through elasticsearch
-- This file is a part of Sailor project
-- Copyright (c) 2016 Nikhil. R <rnikhil96@outlook.com>
-- License: MIT
-- http://sailorproject.org
-------------------------------------------------------------------------------------------



local elasticsearch = require "elasticsearch"
local main_conf = require "conf.conf"
local elastic_conf = main_conf.search[main_conf.sailor.search_engine]
local es = {}

	local client = elasticsearch.client{
	hosts=elastic_conf.hosts,
	params = elastic_conf.params
}

function es.getinfo()
	local data, err = client:info()
	if data==nil then
		return err
	else
		return data

	end
end

function es.index(typeq, idq, body)
	local data, err = client:index{
		index = elastic_conf.index,
		type = typeq,
		id = idq,
		body = body
	}
	if data==nil then
		return err
	else
		return data

	end
end

function es.get(typeq, idq)
	local data, err = client:get{
	  	index = elastic_conf.index,
	  	type = typeq,
	  	id = idq
	}
	if data==nil then
		return err
	else
		return data
	end
end

function es.search(typeq, query)
	local data, err = client:search{
  		index = elastic_conf.index,
  		type = typeq,
  		q = query
		}
	if data==nil then
		return err
	else
		return data

	end
end

function es.searchbody(typeq, body)
	local data, err = client:search{
	  index = elastic_conf.index,
	  type = typeq,
	  body = {
	    query = {
	      match = body
	    }
	  }
}
if data==nil then
		return err
	else
		return data

	end
end

function es.delete(typeq, idq)
	local data, err = client:delete{
	  index = elastic_conf.index,
	  type = typeq,
	  id = idq
}
	if data==nil then
		return err
	else
		return data

	end

end


function es.update(typeq, idq, body)
	local data, err = client:update{
		index = elastic_conf.index,
		type = typeq,
		id = idq,
			body = {
			doc = body
  }
}

	if data==nil then
		return err
	else
		return data

	end

end

return es