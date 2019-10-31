from pgame.service_base import ServiceBase
from tornado.httpclient import AsyncHTTPClient, HTTPRequest
from tornado.ioloop import IOLoop


class HttpSub:
    def __init__(self, http, url, headers=None, body=None, callback=None, extra=None, is_post=False):
        self.http = http
        self.url = url
        self.body = body
        self.headers = headers
        self.cb = callback
        self.is_post = is_post
        self.extra = extra

    def callback(self, response):
        if self.cb is not None:
            if response is None:
                self.cb(None, self.extra)
            elif response.error:
                self.cb(None, self.extra)
                self.http.PGame.log.error(response.error)
            else:
                self.cb(response.body, self.extra)
        self.http.num -= 1


class Http(ServiceBase):
    def init(self):
        self.num = 0
        self.http_list = []
        self.tid = self.PGame.timer.schedule(self.update, 30)
        return 0

    def fini(self):
        self.PGame.timer.cancel(self.tid)
        return 0

    def get(self, url, callback, extra=None):
        hs = HttpSub(self, url, callback=callback, extra=extra)
        self.http_list.append(hs)

    def post(self, url, headers, body, callback=None, extra=None):
        hs = HttpSub(self, url, headers, body, callback, extra, True)
        self.http_list.append(hs)

    async def request(self, hs):
        http_client = AsyncHTTPClient()
        try:
            if hs.is_post:
                request = HTTPRequest(url=hs.url, method="POST", headers=hs.headers, body=hs.body, request_timeout=10)
                res = await http_client.fetch(request)
                hs.callback(res)
            else:
                request = HTTPRequest(url=hs.url, method="GET", request_timeout=10)
                res = await http_client.fetch(request)
                hs.callback(res)
        except Exception as e:
            self.PGame.log.error("http_error:" + str(e))
            hs.callback(None)
        http_client.close()

    def update(self):
        while True:
            if self.num >= 10:
                break
            if len(self.http_list) == 0:
                break
            hs = self.http_list.pop(0)
            self.num += 1
            IOLoop.current().spawn_callback(self.request, hs)

