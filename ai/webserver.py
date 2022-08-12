#Write an API server in python
from transformers import pipeline
import http.server
import socketserver
import json
import os
import sys
import re
import urllib.parse
import urllib.request
import urllib.error
import urllib.parse
import http.client
import http.server
import http.cookies
import http.cookiejar
import http.client

import urllib.parse
pipeDict = {}
modelName="bigscience/bloom-1b7"
pipelineName="text-generation"
generator = pipeline(pipelineName,model=modelName)
pipeDict[modelName+pipelineName] = generator

modelName="distilgpt2"
pipelineName="text-generation"
generator = pipeline(pipelineName,model=modelName)
pipeDict[modelName+pipelineName] = generator


text = "hello world"
#split text into list of words


class MyHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        print("got path: " + self.path)
        path_parts = self.path.split( '/')
        command = path_parts[1]
        
        if command == "ai":
            #Parse query string
            query_components = dict(urllib.parse.parse_qsl(urllib.parse.urlparse(self.path).query))
            params = query_components
            print(params)
            #If no model is specified, use the default model
            if "model" not in params:
                self.send_response(200)
                self.send_header('Content-type', 'text/html')
                self.end_headers()
                self.wfile.write(b'model not found')
                return
            
            modelName = params['model']
            print('model', modelName)
            pipelineName = params['pipeline']
            print('pipeline', pipelineName)
            inputText = params['input']
            print('input', inputText)

            generator = pipeDict[modelName+pipelineName]
            answer = generator(inputText)
            print (answer[0])
        
            #Convert answer to bytes
            ans = bytes(answer[0]["generated_text"], 'utf-8')
            
            
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(ans)
            return
        
        self.send_response(404)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(b'not found')
        return

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length)
        body = body.decode('utf-8')
        body = json.loads(body)
        print(body)
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(b'Hello World!')
        return

#Start the server
PORT = 8080
server_address = ('', PORT)
print('Starting server on port', PORT)
httpd = http.server.HTTPServer(server_address, MyHandler)
httpd.serve_forever()
