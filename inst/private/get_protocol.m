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
## @deftypefn {Function File} {@var{proto} =} get_protocol (@var{ws})
##
## Get communication protocol from the WebSocket "ws".
##
## @noindent
## Given the:
## @itemize @bullet
## @item @var{ws}
## A websocket structure, containing a client and the characteristics of said websocket
## @end itemize
## @var{proto} a protocol structure containing:
##
## @itemize @bullet
## @item @var{fin}
## status of the FIN flag.
## @item @var{op}
## operation code (uint8)
## @item @var{is_masked}
## status of the MASKED flag.
## @item @var{payload_len} (variable size)
## (max uint64) the length of the coming payload.
## @item @var{mask} (optional)
## The payloads mask.
## @end itemize
## 
## @end deftypefn

## Author:        M. Miretti
## Keywords:      websockets-package websockets receive protocol
## Directory:     octave-websockets/inst/private/
## Filename:      get_protocol.m
## Last-Modified: 6 Sep 2020

function proto = get_protocol (ws)

	proto_1 = recv(ws.client, 1);
	proto.fin = logical(bitand(128, proto_1));
	proto.op = bitand(15, proto_1);

	proto_2 = recv(ws.client, 1);
	proto.is_masked = logical(bitand(128, proto_2));
	proto.payload_len = bitand(127, proto_2);

	if proto.payload_len == 126
		len = recv(ws.client, 2);
		proto.payload_len += bitpack(bitunpack(len(2), len(1)), 'uint16');
	elseif proto.payload_len == 127
		len = recv(ws.client, 8);
		proto.payload_len += bitpack(bitunpack(len(8),
						       len(7),
						       len(6),
						       len(5),
						       len(4),
						       len(3),
						       len(2),
						       len(1)), 'uint64');
	endif

	if proto.is_masked
		mask = recv(ws.client, 4);
		proto.mask += bitpack(bitunpack(mask(4),
						mask(3),
						mask(2),
						mask(1)), 'uint32');
	endif

endfunction
