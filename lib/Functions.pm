package  Functions;
require Exporter;


@ISA = qw(Exporter);
@EXPORT = qw( setDateFormat now object_array_uniq flat de_com clone
	today yesterday tomorrow makeID32 makeID64 makeID UID timeStamp TimeStamp time_elapsed tt
	nextbusinessday prevbusinessday date isweekday date2date
	is_numeric iso_epoch T0 T1 Time
	xsd xsd_type
	); 
#elapsed
use strict;
use MIME::Base64 qw(encode_base64url);
use warnings; 
use JSON::XS;
use Time::Moment;
use Gzip::Faster; 
use Time::HiRes qw( time gettimeofday );
#use POSIX::strftime::GNU;
#use POSIX qw(strftime floor);
use constant {
	second => 1,
	minute => 60,
	hour => 3600,
	day => 86400,
};
use List::Util qw {uniq};
 
use Sereal::Encoder; 
our $encoder = Sereal::Encoder->new({canonical=> 1,
		aliased_dedupe_strings => 1,   
});  
use Sereal::Decoder;
my $decoder = Sereal::Decoder->new();

use feature 'state' ;


sub object_array_uniq {
	my %seen; 
	my $A = \@_ ;
	$A = $_[0] if ($#$A == 0 && ref $_[0] eq ref []);	
	my @ret = grep {   !$seen{ $encoder->encode($_) }++ } @$A;
	return wantarray ? @ret : \@ret;
} 

####################################################################################
# ID Gen
####################################################################################
use Math::BaseCalc; 
my $cnv32 = Math::BaseCalc->new( digits => [1..9, "A" .. "H", "J".."N" ,"P" .. "Z"] );
use Digest::xxHash qw {xxhash32_hex xxhash32  xxhash64 xxhash64_hex };
my $seed = 12345;

sub Normalize { local $_ =shift ; if ($_) { s/^\s+|\s+$//g; s/[\r\n\t]/ /g; s/ +/ /g; return uc($_);} else {return "000" } }
sub makeID { return $cnv32->to_base(xxhash32_hex(Normalize(shift)), $seed ); }
sub makeID64 { return xxhash64_hex(shift,  $seed ) }
sub makeID32 { return xxhash32_hex(shift,  $seed )  }

####################################################################################
# UID
####################################################################################

use Data::UUID;
my $ug  = Data::UUID->new;
sub UID {return $cnv32->to_base(murmur_hash($ug->create()))};
####################################################################################
# Type check
####################################################################################

sub is_numeric {  
	return 1 if ( $_[0] =~  /^[+-]?\.?\d+(\.\d*)?([Ee] *([+-]?\d+))?$/)
} 
 


#xsd data types
sub xsd
{  
	local $_ = shift;
	my $v;
	if (/^[\+-]?\d+(\.\d+)?$/i) { $v = $_; }
	elsif (/^(\w*:\w+|<.+?>)$/i) {$v = $_ ;} 
	#elsif (/^\?\w+$/i) {$v = $_ ;} 
	elsif (s/^(true|false)$/lc ($1)/ei) {$v = $_}
	elsif (/^\d{4}-\d\d-\d\dT[\d\:\.]{12,20}Z$/) {$v =qq{"$_"^^xsd:dateTime} }
	elsif (/^\d{4}-\d\d-\d\d$/) {$v =qq{"$_"^^xsd:date}}
	elsif (/^\d{4}-\d\d-\d\dT[0\.\:]{12,20}Z$/) {$v =qq{"$_"^^xsd:date}}
	elsif (/["\n]/)  {
		$_ = encode_base64url(gzip($_));  $v = qq{"Base64:$_"} } 
	else { $v =sprintf '"%s"', $_ }
	return $v;
} 

#xsd data types
sub xsd_type
{  
	local $_ = shift;
	my $v = 'string';
	if (/^(\w*:\w+|<.+?>)$/i) {$v = 'entity'} 
	elsif (/^[\+-]?\d+(\.\d+)?$/i) { $v = 'number' }
	#elsif (/^\?\w+$/i) {$v = $_ ;} 
	elsif (s/^(true|false)$/lc ($1)/ei) {$v = 'boolena'}
	elsif (/^\d{4}-\d\d-\d\dT[\d\:\.]{12,20}Z$/) {$v = 'datetime' }
	elsif (/^\d{4}-\d\d-\d\d$/) {$v ='xsd:date'}
	elsif (/^\d{4}-\d\d-\d\dT[0\.\:]{12,20}Z$/) {$v = 'date' }
	return $v;
} 




####################################################################################
# URL Encode
####################################################################################
our $url_entities = { '<' => '&lt;','>' => '&gt;','&' => '&amp;' };






1;