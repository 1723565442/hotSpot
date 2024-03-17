import os
import urllib.parse

os.environ["OPENAI_API_BASE"] = "http://10.58.0.2:6678/v1"
os.environ["OPENAI_API_KEY"] = "FAKE_KEY"
from http.server import BaseHTTPRequestHandler, HTTPServer
from langchain.chat_models import ChatOpenAI
from langchain.schema import HumanMessage
# 定义一个HTTP请求处理类
class MyHTTPRequestHandler(BaseHTTPRequestHandler):
    # 处理GET请求的函数
    def do_GET(self):
        query = self.path.split('?')[-1]
        tmp = query.replace('_',' ')
        query = "".join(tmp)
        query_decoded = urllib.parse.unquote(query,encoding='utf-8',errors='replace')
        print(query_decoded)
        # 设置响应状态码为200
        self.send_response(200)
        # 设置响应头
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        # 设置响应体
        chat = ChatOpenAI(temperature=1,  max_tokens=2048)
        response = str(chat([HumanMessage(content=query_decoded)]))
        response = response[10:len(response)-1]
        self.wfile.write(response.encode())
# 定义一个HTTP服务器类
class MyHTTPServer(HTTPServer):
    # 重写服务器关闭函数
    def server_close(self):
        print('Server is shutting down...')
        super().server_close()
if __name__ == '__main__':
    # 定义服务器地址和端口号
    server_address = ('', 8081)
    # 创建服务器对象
    httpd = MyHTTPServer(server_address, MyHTTPRequestHandler)
    print('Server is running...')
    # 启动服务器
    httpd.serve_forever()
