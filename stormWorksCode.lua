inputBools = {}
inputFloats = {}
outputBools = {}
outputFloats = {}

for i=1,32,1 do
	table.insert(inputBools, false)
	table.insert(inputFloats, 0.0)
	table.insert(outputBools, false)
	table.insert(outputFloats, 0.0)
end

function onTick()
    setOutput("booleans", 1, "false")
    setOutput("floats", 1, 0)
end

function onDraw()
    -- your code
end

function getInput(type, index)
	async.httpGet(3000, "/inData?type="..type.."&index="..index)	
end
function getOutput(type, index)
	async.httpGet(3000, "/outData?type="..type.."&index="..index)	
end

function setInput(type, index, value)

	if type == "booleans" then
		if value then
			formattedValue = true
		else
			formattedValue = false
		end
	end

	async.httpGet(3000, "/inData?setValue=true&type="..type.."&index="..index.."&value="..formattedValue)	
end

function setOutput(type, index, value)

	if type == "booleans" then
		if value then
			formattedValue = true
		else
			formattedValue = false
		end
	end
	
	async.httpGet(3000, "/outData?setValue=true&type="..type.."&index="..index.."&value="..value)	
end

function updateInputVals()
	for i=1,32,1 do
		getInput('booleans', i)
		getInput('floats', i)
	end
end

function split (inputstr, sep)
   if sep == nil then
      sep = "%s"
   end
   local t={}
   for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
   end
   return t
end

function httpReply(port, request_body, response_body)
    if string.find(request_body, "inData") ~= nil then
    	if string.find(request_body, "type=booleans") ~= nil then
    		if string.find(request_body, "setValue=true") ~= nil then
    			index = tonumber(split(split(request_body, "&")[3], "=")[2])
    		else
    			index = tonumber(split(split(request_body, "&")[2], "=")[2])
    		end
    		if response_body == "true" then
    			inputBools[index] = true
    		else
    			inputBools[index] = false
    		end
    	elseif string.find(request_body, "type=floats") ~= nil then
    		if string.find(request_body, "setValue=true") ~= nil then
    			index = tonumber(split(split(request_body, "&")[3], "=")[2])
    		else
    			index = tonumber(split(split(request_body, "&")[2], "=")[2])
    		end
    		inputFloats[index] = tonumber(response_body)
    	end
    elseif string.find(request_body, 'outData') ~= nil then
    	if string.find(request_body, "type=booleans") ~= nil then
    		if string.find(request_body, "setValue=true") ~= nil then
    			index = tonumber(split(split(request_body, "&")[3], "=")[2])
    		else
    			index = tonumber(split(split(request_body, "&")[2], "=")[2])
    		end
    		if response_body == "true" then
    			outputBools[index] = true
    		else
    			outputBools[index] = false
    		end
    	elseif string.find(request_body, "type=floats") ~= nil then
    		if string.find(request_body, "setValue=true") ~= nil then
    			index = tonumber(split(split(request_body, "&")[3], "=")[2])
    		else
    			index = tonumber(split(split(request_body, "&")[2], "=")[2])
    		end
    		outputFloats[index] = tonumber(response_body)
    	end
    
    end
end
