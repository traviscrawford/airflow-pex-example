#!/usr/bin/env python
# -*- coding: utf-8 -*-

from gunicorn.app.wsgiapp import WSGIApplication

if __name__ == '__main__':
    WSGIApplication("%(prog)s [OPTIONS] [APP_MODULE]").run()
