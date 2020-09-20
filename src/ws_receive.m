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
## @deftypefn {Function File} {@var{resp} =} ws_receive (@var{ws})
##
## Receive from the WebSocket "ws".
##
## @noindent
## Given the:
## @itemize @bullet
## @item @var{ws}
## A websocket structure, containing a client and the characteristics of said websocket
## @end itemize
## @var{resp} a string (if received text) or a set of binary values (if received bin values).
## 
## @end deftypefn

## Author:        M. Miretti
## Keywords:      websockets-package websockets receive
## Directory:     octave-websockets/inst/
## Filename:      ws_receive.m
## Last-Modified: 6 Sep 2020

function resp = ws_receive (ws)
	
	proto = get_protocol(ws);

	if proto.fin
		payload = recv(ws.client, proto.payload_len);
		switch proto.op
			case 0  % Continuation frame
				% pass
			case 1  % Text frame
				resp = char(payload);
			case 2  % Binary frame
				resp = dec2bin(payload);
			case 8  % Connection close
				ws.status = "closed";
			case 9  % Ping
				resp = "ping";
				% send pong
			case 10  % Pong
				resp = "pong";

			otherwise  % OPCODE ERROR
				resp = -1;

		endswitch
	else
		disp('messages without FIN are not supported yet')
	endif

endfunction
