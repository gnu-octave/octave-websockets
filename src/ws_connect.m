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
## @deftypefn {Function File} {@var{ws} =} ws_connect (@var{host}, @var{uri})
## @deftypefnx {Function File} {@var{ws} =} ws_connect (@var{host}, @var{uri}, @var{port})
##
## Connect to the WebSocket server at the given ``uri``.
##
## @noindent
## Given the:
## @itemize @bullet
## @item @var{host}
## the IP address of the host, in string format.
## @item @var{uri}
## the uri (string) to consult in the websocket host, it must start with "/".
## @item @var{port}
## the target port (integer) of the host
## @end itemize
## @var{ws} a WebSocket sctructure with the following items.
## @itemize @bullet
## @item @var{client}
## a specific TCP socket for this connection.
## @item @var{host}
## the IP address of the host, in string format.
## @item @var{uri}
## the uri (string) to consult in the websocket host, it must start with "/".
## @item @var{port}
## the target port (integer) of the host
## @end itemize
## 
## @end deftypefn

## Author:        M. Miretti
## Keywords:      websockets-package websockets connect
## Directory:     octave-websockets/inst/
## Filename:      ws_connect.m
## Last-Modified: 6 Sep 2020

function ws = ws_connect (host, uri, port = 80)

	ws.host = host;
	ws.uri = uri;
	ws.port = port;

	sec_websocket_key =  generate_secret_key();
	expected_key = calculate_expected_key(sec_websocket_key);

	ws.client = socket(AF_INET, SOCK_STREAM, 0);
	server_info = struct("addr", host, "port", port);
	rc = connect(ws.client, server_info);

	header = build_handshake_header(uri, host, port, sec_websocket_key);
	send(ws.client, header);

	handshake_r = recv(ws.client, 129);
	c_handshake = char(handshake_r);

	ACCEPTANCE_STRING = "Sec-WebSocket-Accept";
	accept_index = strfind(c_handshake, ACCEPTANCE_STRING);
	response_key = substr(c_handshake, accept_index + length(ACCEPTANCE_STRING) + 2, 28);

	key_compare = strcmp(expected_key, response_key);

	if key_compare
		ws.status = "connected";
	else
		ws.status = "disconneced";
	endif

endfunction
