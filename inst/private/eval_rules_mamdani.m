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
## @deftypefn {Function File} {@var{rule_output} =} eval_rules_mamdani (@var{fis}, @var{firing_strength}, @var{num_points})
##
## Return the fuzzy output for each rule and for each output variable of a
## Mamdani-type FIS (that is, an FIS that does not have constant or linear
## output membership functions).
##
## The firing strength of each rule is given by a row vector of length Q, where
## Q is the number of rules in the FIS:
## @example
## @group
##  rule_1             rule_2             ... rule_Q
## [firing_strength(1) firing_strength(2) ... firing_strength(Q)]
## @end group
## @end example
##
## The implication method and fuzzy consequent for each rule are given by:
## @example
## @group
## fis.impMethod
## fis.rule(i).consequent     for i = 1..Q
## @end group
## @end example
##
## Finally, the output of the function is a num_points x (Q*L) matrix, where
## num_points is the number of points at which the fuzzy output is evaluated,
## Q is the number of rules, and L is the number of outputs of the FIS.
## Each column of this matrix gives the y-values of the corresponding fuzzy
## output (of a single rule for a single FIS output).
##
## @example
## @group
##              num_rules cols    num_rules cols          num_rules cols 
##             ---------------   ---------------         ---------------
##             out_1 ... out_1   out_2 ... out_2   ...   out_L ... out_L
##          1 [                                                         ]
##          2 [                                                         ]
##        ... [                                                         ]
## num_points [                                                         ]
## @end group
## @end example
##
## Function eval_rules_mamdani does no error checking of the argument values.
##
## @end deftypefn

## Author:        L. Markowsky
## Keywords:      fuzzy-logic-toolkit fuzzy fuzzy-inference-system fis
## Directory:     fuzzy-logic-toolkit/inst/private/
## Filename:      eval_rules_mamdani.m
## Last-Modified: 20 May 2011

function rule_output = eval_rules_mamdani (fis, firing_strength, num_points)

  num_rules = columns (fis.rule);                 ## num_rules   == Q (above)
  num_outputs = columns (fis.output);             ## num_outputs == L

  ## Initialize output matrix to prevent inefficient resizing.
  rule_output = zeros (num_points, num_rules*num_outputs);

  ## Compute the fuzzy output for each (rule, output) pair:
  ##   1. Apply the FIS implication method to find the fuzzy outputs
  ##      for the current (rule, output) pair.
  ##   2. Store the result as a column in the rule_output matrix.

  for i = 1 : num_rules
    rule = fis.rule(i);
    rule_matching_degree = firing_strength(i);

    if (rule_matching_degree != 0)
      for j = 1 : num_outputs

        ## Compute the fuzzy output for this (rule, output) pair.

        mf_index = rule.consequent(j);
        if (mf_index != 0)
          range = fis.output(j).range;
          mf = fis.output(j).mf(mf_index);
          x = linspace (range(1), range(2), num_points);
          fuzzy_out = evalmf (x, mf.params, mf.type);
          switch (fis.impMethod)
            case 'min'
              fuzzy_out = min (rule_matching_degree, fuzzy_out);
            case 'prod'
              fuzzy_out *= rule_matching_degree;
            otherwise
              fuzzy_out = str2func (fis.impMethod) (rule_matching_degree, ...
                                                    fuzzy_out);
          endswitch

          ## Store result in column of rule_output corresponding
          ## to the (rule, output) pair.

          rule_output(:, (i - 1) * num_outputs + j) = fuzzy_out';
        endif
      endfor
    endif

  endfor
endfunction