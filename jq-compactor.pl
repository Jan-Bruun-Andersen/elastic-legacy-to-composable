#!/bin/perl -0

=pod

=head1 NAME

jq-compactor

=head1 DESCRIPTION

jq-compactor is a script that will partially compact a pretty-printed
JSON file as produced by L<jq|https://stedolan.github.io/jq/> by putting
the inner-most level of braces on a single line.

The script was found in a
L<discussion on GitHub|https://github.com/stedolan/jq/issues/643#issuecomment-392384015>
on how to partially compact the JSON produced by 'jq':

=head1 EXAMPLE

An input like this:

    {
      "mappings": {
	"dynamic": "true",
	"properties": {
	  "DestinationIPAddress": {          
	    "type": "ip"
	  },
	  "Device IP Address": {
	    "type": "ip"
	  },
	  "NAS-IP-Address": {
	    "type": "ip"
	  }
	}
      }
    }

will be turned into this more compact form:

    {
      "mappings": {
	"dynamic": "true",
	"properties": {
	  "DestinationIPAddress": { "type": "ip" },
	  "Device IP Address": { "type": "ip" },
	  "NAS-IP-Address": { "type": "ip" }
	}
      }
    }

=head1 AUTHOR

yanOnGithub - L<https://github.com/yanOnGithub>

=cut

while(<>) {
  my @array = split(/(\{[^{}]+\})/, $_);
  for(my $a = 1; $a < scalar(@array); $a += 2) {
      $array[$a] =~ s!^\s+!!mg;
      $array[$a] =~ s![\r\n]+! !g;
  }
  print join "", @array;
}
