#!/usr/bin/perl

### Create coordinates.log from kml-files:
### grep -A12 "BTS-" /mnt/c/Job_IT/2017_ECP/LOG/KML/BTS-*.kml | grep "<coordinates>" > coordinates.log
### cat coordinates.log | ./HaverSinus.pl #BTS_radius(km)

use Math::Trig;
use Math::Trig 'great_circle_distance';
#use Math::Trig 'great_circle_direction';
#use Math::Trig ':radial';

$R=6371;  							# Earth's radius (km)
if (!$ARGV[0]) {
	print "\n\nUsage:\ngrep -A12 'BTS-' /.../BTS-*.kml | grep '<coordinates>' > coordinates.log\n";
	print "cat coordinates.log | ./HaverSinus.pl #BTS_radius\nRoman Mamon 201710\n";
	exit 0;
}
elsif ( $ARGV[0] =~ /^(\d+)_(\d+)$/ ) {
	$bts = $1;
	$radius= $2;						# Around BTS radius
}

open COR, "< coordinates.log" or die $!;			# grep coordinates for 1st BTS
while (<COR>) {
	if ( $_ =~ /^.*BTS-$bts\.kml-\s+\<coordinates\>\s+0(.*)\,\s+(.*)\,0\<\/coordinates\>$/ ) {

		$lon1=deg2rad($1);
		$lat1=deg2rad($2);				# $2*3.14/180

		$cl1=cos($lat1);				# 1st point for Azimut
		$sl1=sin($lat1);
	}
}
close COR;

open ALF, "> $bts-alfa.txt" or die $!;				# Creating sector-files for neighbors
open BET, "> $bts-betta.txt" or die $!;
open GAM, "> $bts-gamma.txt" or die $!;

print ALF $bts."1\n";						# The head of files
print ALF $bts."20\n";
print ALF $bts."30\n";
print BET $bts."2\n";
print BET $bts."10\n";
print BET $bts."30\n";
print GAM $bts."3\n";
print GAM $bts."10\n";
print GAM $bts."20\n";

$n=0;															# Neighbors counter
while (<STDIN>) {
	## Pattern from coordinates.log
#	if ( $_ =~ /^.*BTS-(\d+)\.kml-\s+\<coordinates\>\s+0(.*)\,\s+(.*)\,0\<\/coordinates\>$/ ) {			# Unrem to include 1900 and LTE BTS-numbers
	if ( $_ =~ /^.*BTS-(\d+)\.kml-\s+\<coordinates\>\s+0(.*)\,\s+(.*)\,0\<\/coordinates\>$/ && $1<2901 ) {		# 2900 - Last BTS CDMA-850

		$neighbor=$1;
		$lon2=deg2rad($2);				# grep coordinates for 2nd BTS
		$lat2=deg2rad($3);

		############################# Azimut Calc #################################################
		$cl2=cos($lat2);				## 2nd point for Azimut
		$sl2=sin($lat2);
		$delta=$lon2-$lon1;
		$cdelta=cos($delta);
		$sdelta=sin($delta);

		$x=($cl1*$sl2)-($sl1*$cl2*$cdelta);
		$y=$sdelta*$cl2;
		if ( $x != 0 ) { $z=rad2deg(atan(-$y/$x)); }	# The angle between the leg and the hypotenuse is equal to the arctangent of the ratio of the legs
								# see wiki.gis-lab.info for help ( translated from python))
		if ( $x<0 ) { $z=$z+180; }
		$z2 = ($z+180.)%360. - 180.;
		$z2 = - deg2rad($z2);

		$anglerad2 = $z2 - ( (2*3.14)*int(($2/(2*3.14))) );
		$angledeg = 360+rad2deg($anglerad2);

		##############################################################################

		$distance = great_circle_distance($lon1, pi/2 - $lat1, $lon2, pi/2 - $lat2, $R);	# Distance between two points - see perldoc Math::Trig
		if ( $distance <= $radius && $distance != 0 ) {						# For user radius and if BTS isn't itself
			$n++; print "\n$n\)\n";
			print "\nDistance BTS-$bts - $neighbor = $distance km";				# Print distance
			print "\nDirection BTS-$bts - $neighbor = ".$angledeg." degrees\n";		# Print azimut

			if ( $bts =~/^\d$/ ) { $bts="000".$bts; }					# Aligment bts and neighbor name
			elsif ( $bts =~/^\d{2}$/ ) { $bts="00".$bts; }
			elsif ( $bts =~/^\d{3}$/ ) { $bts="0".$bts; }

			if ( $neighbor =~/^\d$/ ) { $neighbor="000".$neighbor; }
			elsif ( $neighbor =~/^\d{2}$/ ) { $neighbor="00".$neighbor; }
			elsif ( $neighbor =~/^\d{3}$/ ) { $neighbor="0".$neighbor; }
			
			### Grep real azimuts of neib
			$grep_az1="grep CDMA800_".$neighbor."_1 AZIMUT_RES.txt";
			$grep_az2="grep CDMA800_".$neighbor."_2 AZIMUT_RES.txt";
			$grep_az3="grep CDMA800_".$neighbor."_3 AZIMUT_RES.txt";
			$az1=`$grep_az1`;
			$az2=`$grep_az2`;
			$az3=`$grep_az3`;
			if ( $az1 =~ /KML\/CDMA800_\d+_1.kml\s<td\salign=\'center\'>(\d+)<\/td>/ ) { $nei1=$1; }
			if ( $az2 =~ /KML\/CDMA800_\d+_2.kml\s<td\salign=\'center\'>(\d+)<\/td>/ ) { $nei2=$1; }
			if ( $az3 =~ /KML\/CDMA800_\d+_3.kml\s<td\salign=\'center\'>(\d+)<\/td>/ ) { $nei3=$1; }

			if ( $angledeg >= 180 ) { $back_az = $angledeg - 180; }						# Rotate straight azimut
			elsif ( $angledeg < 180 ) { $back_az = $angledeg + 180;	}

			if ( $back_az > ($nei1-60) && $back_az < ($nei1+60)  ) { $back_sec = 1; }			# Calculate back sector
			if ( $back_az > ($nei2-60) && $back_az < ($nei2+60)  ) { $back_sec = 2; }
			if ( $back_az > ($nei3-60) && $back_az < ($nei3+60)  ) { $back_sec = 3; }
			
			if ( (60 > $angledeg && $angledeg >= 0) || (360 > $angledeg && $angledeg >= 300) ) {		# Staright sec is Alfa
				print "Straight sec Alfa - Back sec $back_sec\n";
				print ALF $neighbor.$back_sec."1\n";							# Back sector - ALWAYS 1st priority
			}
			elsif ( 180 > $angledeg && $angledeg >= 60 ) {
				print "Straight sec Betta - Back sec $back_sec\n";
				print BET $neighbor.$back_sec."1\n";
			}
			elsif ( 300 > $angledeg && $angledeg >= 180 ) {
				print "Straight sec Gamma - Back sec $back_sec\n";
				print GAM $neighbor.$back_sec."1\n";
			}
		}
	}
}
close ALF;
close BET;
close GAM;

print "\n$bts-alfa|betta|gamma.txt was generate\n";

## HaverSin - eq for func great_circle_distance
### $sin1=sin(($lat1-$lat2)/2);
### $sin2=sin(($lon1-$lon2)/2);
### print "\nDestination = ".2*$R*asin(sqrt($sin1*$sin1+$sin2*$sin2*cos($lat1)*cos($lat2)))."\n";

exit 0;
