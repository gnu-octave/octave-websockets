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
## @deftypefn {Function File} {@var{s} =} calculate_expected_key (@var{secret_key})
##
## @noindent
## Given the:
## @itemize @bullet
## @item @var{secret_key}
## the random secret key (string) given by the client in the handshake header, it MUST
## have a size of 24.
## @end itemize
## @var{s} is the expected string, resultant of the base64 encoding of the SHA1
## hash of the Globally Unique Identifier appended to the secret_key.
##
## @noindent
## Return:
## @itemize @bullet
## @item @var{s}
## a base64 encoded string with size 28
## @end itemize
##
## given the input string "dGhlIHNhbXBsZSBub25jZQ==", it will be concatenated
## with the GUID, resulting in "dGhlIHNhbXBsZSBub25jZQ==258EAFA5-E914-47DA-95CA-
## C5AB0DC85B11" then the SHA-1 of this string will be computed giving the value
## "b37a4f2cc0624f1690f64606cf385945b2bec4ea", which will then be base64 encoded
## and returned as "s3pPLMBiTxaQ9kYGzzhZRbK+xOo=".
##
##
## @example
## s = calculate_expected_key ("dGhlIHNhbXBsZSBub25jZQ==")
## -| s = s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
## @end example
##
## Because calculate_expected_key is a private function, called only by the 
## module function ws_connect, it does no error checking of the argument values.
## @end deftypefn

## Author:        M. Miretti
## Keywords:      websockets-package websockets private key-calculation
## Directory:     octave-websockets/inst/private/
## Filename:      calculate_expected_key.m
## Last-Modified: 31 Aug 2020

function s = calculate_expected_key (secret_key)

	GUID = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";

	hashy = hash('SHA1', strcat(secret_key, GUID));
	
	hashy_cell = {};
	for i = 1:20;
		hashy_cell(i) = hex2dec(substr(hashy, ((2 * (i - 1)) + 1), 2));
	endfor
	
	hashy_arr = cell2mat(hashy_cell);
	
	s = base64encode(hashy_arr, true);

endfunction
