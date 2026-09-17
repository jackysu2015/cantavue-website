"""Serve the release output with Sites-compatible clean HTML paths locally."""
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlsplit

class CleanPaths(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def translate_path(self, path):
        resolved=Path(super().translate_path(path))
        if not resolved.exists() and not Path(urlsplit(path).path).suffix:
            html=resolved.with_suffix('.html')
            if html.is_file(): return str(html)
        return str(resolved)

if __name__=='__main__':
    public=Path(__file__).resolve().parents[1]/'dist'
    print('CantaVue preview: http://127.0.0.1:4177',flush=True)
    ThreadingHTTPServer(('127.0.0.1',4177),partial(CleanPaths,directory=str(public))).serve_forever()
