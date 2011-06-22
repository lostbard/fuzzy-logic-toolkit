## Copyright (C) 2011 L. Markowsky <lmarkov@users.sourceforge.net>
##
## This file is part of the fuzzy-logic-toolkit.
##
## The fuzzy-logic-toolkit is free software; you can redistribute it
## and/or modify it under the terms of the GNU General Public License
## as published by the Free Software Foundation; either version 3 of
## the License, or (at your option) any later version.
##
## The fuzzy-logic-toolkit is distributed in the hope that it will be
## useful, but WITHOUT ANY WARRANTY; without even the implied warranty
## of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with the fuzzy-logic-toolkit; see the file COPYING.  If not,
## see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Script File} {} tipping_demo
##
## Demonstrate the use of the fuzzy_logic_toolkit to read and evaluate a
## Sugeno-type FIS stored in a file.
##
## The demo:
## @itemize @minus
## @item
## reads an FIS structure from a file
## @item
## plots the input and output membership functions
## @item
## plots the output as a function of the inputs
## @item
## evaluates the Sugeno-type FIS for six inputs
## @end itemize
##
## @seealso{commandline_demo, heart_demo, mamdani_demo}
## @end deftypefn

## Author:        L. Markowsky
## Keywords:      fuzzy-logic-toolkit fuzzy tests demos
## Note:          This example is based on an assignment written by
##                Dr. Bruce Segee (University of Maine Dept. of ECE).
## Directory:     fuzzy-logic-toolkit/inst
## Filename:      tipping_demo.m
## Last-Modified: 7 Jun 2011

## Read the FIS structure from a file.
fis = readfis ('sugeno-tip-calculator.fis');

## Plot the input and output membership functions.
plotmf (fis, 'input', 1);
plotmf (fis, 'input', 2);
plotmf (fis, 'output', 1);

## Plot the Tip as a function of Food-Quality and Service.
gensurf (fis);

## Calculate the Tip for 6 sets of input values: 
puts ("\nFor the following values of (Food Quality, Service):\n\n");
food_service = [1 1; 5 5; 10 10; 4 6; 6 4; 7 4]
puts ("\nThe Tip is:\n\n");
tip = evalfis (food_service, fis, 1001)