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
## @deftypefn {Function File} {@var{firing_strength} =} eval_firing_strength (@var{fis}, @var{rule_input})
##
## Return the firing strength for each FIS rule given a matrix of matching
## degrees of each (rule, input) pair.
##
## The second argument (@var{rule_input}) gives the fuzzified input values to
## the FIS rules as a Q x N matrix:
##
## @example
## @group
##          in_1   in_2   ...  in_N
## rule_1  [mu_11  mu_12  ...  mu_1N]
## rule_2  [mu_21  mu_22  ...  mu_2N]
##         [              ...       ]
## rule_Q  [mu_Q1  mu_Q2  ...  mu_QN]
## @end group
## @end example
##
## @noindent
## where Q is the number of rules and N is the number of inputs to the FIS.
##
## The fuzzy antecedent, connection, and weight for each rule are given by:
## @itemize @bullet
## @item
## @var{fis.rule(i).antecedent}
## @item
## @var{fis.rule(i).connection}
## @item
## @var{fis.rule(i).weight}
## @end itemize
##
## @noindent
## where i = 1 .. Q.
##
## The output is a row vector of length Q.
##
## Function eval_firing_strength does no error checking of the argument values.
##
## @end deftypefn

## Author:        L. Markowsky
## Keywords:      fuzzy-logic-toolkit fuzzy fuzzy-inference-system fis
## Directory:     fuzzy-logic-toolkit/inst/private/
## Filename:      eval_firing_strength.m
## Version:       0.2
## Last-Modified: 20 May 2011

function firing_strength = eval_firing_strength (fis, rule_input)

  num_rules = columns (fis.rule);                 ## num_rules   == Q (above)
  num_inputs = columns (fis.input);               ## num_inputs  == N

  ## Initialize output matrix to prevent inefficient resizing.
  firing_strength = zeros (num_rules);

  ## For each rule
  ##    1. Apply connection to find matching degree of the rule antecedent.
  ##    2. Multiply by weight of the rule to find degree of the rule.

  for i = 1 : num_rules
    rule = fis.rule(i);

    ## Collect mu values for all input variables in the rule's antecedent.
    antecedent_mus = [];
    for j = 1 : num_inputs
      if (rule.antecedent(j) != 0)
        mu = rule_input(i, j);
        antecedent_mus = [antecedent_mus mu];
      endif
    endfor

    ## Compute matching degree of the rule.
    if (rule.connection == 1)
      connect = fis.andMethod;
    else
      connect = fis.orMethod;
    endif
    switch (connect)
      case 'min'
        firing_strength(i) = rule.weight * min (antecedent_mus);
      case 'max'
        firing_strength(i) = rule.weight * max (antecedent_mus);
      otherwise
        firing_strength(i) = rule.weight * ...
                             str2func (connect) (antecedent_mus);
    endswitch
  endfor
endfunction
