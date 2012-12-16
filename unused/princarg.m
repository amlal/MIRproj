%PRINCARG
%Wraps phase to -pi to pi
%
%phase_out=princarg(phase_in)
%based on http://www.daimi.au.dk/~jones/dsp/matlab/princarg.m

function phase_out=princarg(phase_in)

phase_out = mod(phase_in+pi,-2*pi)+pi;