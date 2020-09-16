## Copyright (C) 2020 M. Miretti <marco.miretti@gmail.com>
##
## This file is part of the websockets-package.
##
## The websockets-package is free software; you can redistribute it
## and/or modify it under the terms of the GNU General Public License
## as published by the Free Software Foundation; either version 3 of
## the License, or (at your option) any later version.
##
## The websockets-package is distributed in the hope that it will be
## useful, but WITHOUT ANY WARRANTY; without even the implied warranty
## of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with the fuzzy-logic-toolkit; see the file COPYING.  If not,
## see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{header} =} build_handshake_header (@var{uri}, @var{host}, @var{port}, @var{secret_key})
##
## @noindent
## Given the:
## @itemize @bullet
## @item @var{uri}
## the uri (string) to consult in the websocket host, it must start with "/".
## @item @var{host}
## the IP address of the host, in string format.
## @item @var{port}
## the target port (integer) of the host
## @item @var{secret_key}
## the random secret key (string) given by the client in the handshake header, it MUST
## have a size of 24.
## @end itemize
## @var{heder} is the header string to be sent in the handshake of a TCP connection to
## negotiate a communication using the Websocket protocol.
## 
## @end deftypefn
##
## @example
## header = build_handshake_header ("/chat", "server.example.com", 80, "dGhlIHNhbXBsZSBub25jZQ==")
## -| header = GET /chat HTTP/1.1
## -| Host: server.example.com:80
## -| Upgrade: websocket
## -| Connection: Upgrade
## -| Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
## -| Sec-WebSocket-Version: 13
## @end example

## Author:        M. Miretti
## Keywords:      websockets-package websockets private key-generation
## Directory:     octave-websockets/inst/private/
## Filename:      generate_secret_key.m
## Last-Modified: 2 Sep 2020

function header = build_handshake_header (uri, host, port, key)
	header = cstrcat("GET ", uri," HTTP/1.1\r\n",
			 "Host: ", host,":", int2str(port),"\r\n",
			 "Upgrade: websocket\r\n",
			 "Connection: Upgrade\r\n",
			 "Sec-WebSocket-Key: ", key, "\r\n",
			 "Sec-WebSocket-Version: 13\r\n\r\n");

endfunction
