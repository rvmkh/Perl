#!/usr/bin/perl -w

my $brel1="";
my $nci = "";
my $fci = "";
my $cpc = "";
my $tmr = "";
my $cdpn = "";
my $cpn = "";
my $nb  = "";
my $nbl = "";
my $nai = "";
my $na  = "";
my $evind="";
my $prsnt="";
my $param="";
my $enn="";
my $name="";
my $bci="";
my $obci="";
my $uuind="";
my $hist="";
my $rdn="";
my $inf_ind="";
my $hex_string;
my $header;
my $ofci;
my $gennum;
my $cdi;
my $gni;
my $adi;

my %chin;
my %cpsi;
my %endm;
my %ii;
my %endi;
my %isdu;
my %hold;
my %isda;
my %echo;
my %sccp;
my %cpci;
my %request_13;
my %response_2;
my %response_13;
my %request_2;
my %ndi;
my %cpari;
my %hpi;
my %cpcri;
my %chiri;
my %sii;
my %mciri;
my %inn;
my %nai;
my %npi;
my %oei;
my %param_name;
my %cugci;
my %ssi;
my %cliri;
my %nqi;
my %nso;
my %gni_ni;

while (<STDIN>) {

	if ($_ =~ /^\s*]\s+\S+\s\S\s(T|R)\sHEADER\s*=\s*(\S\S)\s*$/i) {
		$header = $2;
                if ($1 eq "R"){
                        printf "\n\nIncoming message\t";
                }else{
			printf "\n\nOutgoing message\t";
		}
		my $line2 = "";
		my $line1 = <STDIN>;
		if ( length($line1) >= 74 ) {
			$line2 = <STDIN>;
		}
		if ($line2 =~ /^\s{6}(\S)+\s*$/) {
			$hex_string = $line1 . $line2;
		} else {
				$hex_string = $line1;
		}
			$hex_string =~ s/\s+//gm;
		if ($header eq "06") {
			print "Address Complete (ACM) :  ";
			print "$hex_string\n\n";
			parse_2FO($hex_string); 
		}elsif ($header eq "0C") { 
			print "Release (REL) :  ";
			print "$hex_string\n\n";
			parse_REL ($hex_string); 
		}elsif ($header eq "01") {
			print "Initial address (IAM) : ";
			print "\n\t\t$hex_string\n";
			parse_IAM ($hex_string);
		}elsif ($header eq "09") {
			print "Answer (ANM) : ";
			print "$hex_string\n\n";
			parse_ANM ($hex_string);
		}elsif ($header eq "13") {
			print "Blocking (BLO) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "15") {
			print "Blocking acknowledgement (BLA) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "2C") {
			print "Call progress (CPG) : ";
			print "$hex_string\n\n";
			parse_1FO ($hex_string);
		}elsif ($header eq "18") {
			print "Circuit group blocking (CGB) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "1A") {
			print "Circuit group blocking acknowledgement (CGBA) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "2A") {
			print "Circuit group query (CQM) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "2B") {
			print "Circuit group query response (CQR) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "17") {
			print "Circuit group reset (GRS) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "29") {
			print "Circuit group reset acknowledgement (GRA) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "19") {
			print "Circuit group unblocking (CGU) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "1B") {
			print "Circuit group unblocking acknowledgement (CGUA) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "31") {
			print "Charge information (CRG) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "2F") {
			print "Confusion (CFN) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "07") {
			print "Connect (CON) : ";
			print "$hex_string\n\n";
                        parse_2FO($hex_string);
		}elsif ($header eq "05") {
			print "Continuity (COT) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "11") {
			print "Continuity check request (CCR) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "33") {
			print "Facility (FAC) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "20") {
			print "Facility accepted (FAA) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "21") {
			print "Facility rejected (FRJ) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "1F") {
			print "Facility request (FAR) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "08") {
			print "Forward transfer (FOT) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "36") {
			print "Identification request (IDR) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "37") {
			print "Identification response (IRS) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "04") {
			print "Information (INF) : ";
			print "$hex_string\n\n";
                        parse_2FO($hex_string);
		}elsif ($header eq "03") {
			print "Information request (INR) : ";
			print "$hex_string\n\n";
                        parse_2FO($hex_string);
		}elsif ($header eq "22") {
			print "Loop back acknowledgement (LPA) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "32") {
			print "Network resource management (NRM) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "30") {
			print "Overload (OLM) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "28") {
			print "Pass along (PAM) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "10") {
			print "Release complete (RLC) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "12") {
			print "Reset circuit (RSC) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "0E") {
			print "Resume (RES) : ";
			print "$hex_string\n\n";
			parse_1FO ($hex_string);
		}elsif ($header eq "38") {
			print "Segmentation (SGM) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "02") {
			print "Subsequent address (SAM) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "0D") {
			print "Suspend (SUS) : ";
			print "$hex_string\n\n";
			parse_1FO($hex_string);
		}elsif ($header eq "14") {
			print "Unblocking (UBL) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "16") {
			print "Unblocking acknowledgement (UBA) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "2E") {
			print "tUnequipped CIC (UCIC) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "35") {
			print "User Part available (UPA) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "34") {
			print "User Part test (UPT) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "2D") {
			print "User-to-user information (USR) : ";
			print "$hex_string\n\n";
		}elsif ($header eq "27") {
			print "Delayed release (DRS) : ";
			print "$hex_string\n\n";
		}else{print "Reserved"}
	}
	if ($_ =~ /\s*]\s*SG=L10E07\S*/i) {
		print "\n\n$_\n";
	}
	if ($_ =~ /\s*]\s*1\s*\d\d-\d\d-\d\d\S*/i) {
		print "$_";
	}
	
}
#################################################################################################
sub hex2bin {
	(my $hex_str) =@_;
	my %h2b = ('0' => "0000",
		'1' => "0001",
		'2' => "0010",
		'3' => "0011",
		'4' => "0100",
		'5' => "0101",
		'6' => "0110",
		'7' => "0111",
		'8' => "1000",
		'9' => "1001",
		'A' => "1010",
		'B' => "1011",
		'C' => "1100",
		'D' => "1101",
		'E' => "1110",
		'F' => "1111");
	my $bin_str = "";
	while ($hex_str =~ /^(\S)/) {
		$bin_str .= $h2b{$1};
		$hex_str = $';
	}
	return $bin_str;
}

###################################################################################################
##########################        MESSAGE PROCESSING    ###########################################
###################################################################################################

#################################### Release (REL) ################################################

sub parse_REL {

	if ($hex_string =~ /\S{2}(\S{2})\S(\S)\S+/i){			#### Pv(Po)(Lv)()
		$pnt_o=$1;
		$lngt=oct('0x'.$2)*2;
	}else{print "\nCan`t match hex1 for REL\n"}
	if ($hex_string =~ /\S{6}(\S{$lngt})(\S{2})\S(\S)(\S*)/i || $hex_string =~ /\S{6}(\S{$lngt})0\S/) {
		$cause_ind=hex2bin($1);
		print "\nCause Indicator : \n\t";
		parse_CAUSE ($cause_ind);
		$name=$2;
		if($3) {$lngt=oct('0x'.$3)*2;}
		$param=$4;
		if ($pnt_o eq "00") {print "\nThere are no Optional Param. are present\n"}
		else { parse_param ($param,$lngt,$name) }
	}else {print "\nCan`t match hex2 for REL\n"}
}

########### IAM = (nci1)(fci2)(cpc1)(tmr1)Pv(Po)(Lv_0.5)CPN_4-11OPT

sub parse_IAM {

	if ( $hex_string =~ /(\S{2})(\S{4})(\S{2})(\S{2})\S{2}(\S{2})\S(\S)\S+/i ) {
		$nci=hex2bin("$1");
		parse_NCI ($nci);
		$fci=hex2bin("$2");
		parse_FCI($fci);
		$cpc=hex2bin("$3");
		parse_CallingPartCtgr($cpc);
		$tmr=hex2bin("$4");
		parse_TMR($tmr);
		$pnt_o=$5;
		$lngt=oct('0x'.$6)*2;
	}else{print "\nCan`t match hex1 for IAM\n"}
	if ($pnt_o eq "00") {print "\nThere are no Optional Param. are present\n"}
	else {
		if ( $hex_string =~ /\S{16}(\S{$lngt})(\S{2})\S(\S)(\S*)/i ) {	#### hex1(var)(name_o)(lngt_o_0.5)(opt)
			$cdpn=$1;		##### don`t hex2bin cuz NB into cdpn in dec
			parse_CDPN($cdpn);
			$name=$2;
			$lngt=oct('0x'.$3)*2;
			$param=$4;
		}else{print "\nCan`t match hex2 for IAM\n"}
		parse_param ($param,$lngt,$name);
	}
}

########################### Call progress (CPG) || Suspend (SUS) || Resume (RES) #############################################

sub parse_1FO {

	if ($hex_string =~ /(\S{2})(\S{2})(\S{2})\S(\S)(\S*)/i || $hex_string =~ /(\S{2})(\S{2})0\S/i) {    ### 1F1byte + opt
		if ($header eq "2C") {
			$evind=hex2bin($1);
			print "\nEvent information\n";
			parse_EVIND($evind);
		}elsif ($header eq "0D" || $header eq "0E") {
			$sus=hex2bin($1);
			print "\nSuspend/resume indicators\n";
			parse_SRI($sus);
		}
		$pnt_o=$2;
                if ($pnt_o eq "00") {print "\nThere are no Optional Param. are present\n"}
		else {
			$name=$3;
			$lngt=oct('0x'.$4)*2;
			$param=$5;
        	        if ($pnt_o eq "00") {print "\nThere are no Optional Param. are present\n"}
                	parse_param ($param,$lngt,$name)
		}
        }else{ print "\nCan`t match hex for CPG\n" }
}

##########################_Answer_(ANM)_###########################################################

sub parse_ANM {

	if ($hex_string =~ /(\S{2})(\S{2})\S(\S)(\S*)/i || $hex_string =~ /(\S{2})0\S/){
		$pnt_o=$1;
		if ($pnt_o eq "00") {print "\nThere are no Optional Param. are present\n"}
		else {
			$name = $2;
			$lngt=oct('0x'.$3)*2;
			$param = $4;
			parse_param ($param,$lngt,$name);
		}
	}else { print "Cant match ANM-hex" }
}

###############_Connect_(CON)_||_Information_(INF)_####################

sub parse_2FO {
				## Fixed part 2 bytes + Point1 + Name1 + Lngt0.5 + $param

	if ($hex_string =~ /(\S{4})(\S{2})(\S{2})\S(\S)(\S*)/i || $hex_string =~ /(\S{4})(\S{2})0\S/i) {
		$name = $3;
		if ($4) {$lngt=oct('0x'.$4)*2;}
		$pnt_o=$2;
		if ( $header eq "06" || $header eq "07") {	##### case CON or ACM (Backward Call Ind. - Fix)
			$bci = hex2bin($1);
			print "\nBackward Call Indicator\n";
			parse_BCI($bci);
		}elsif ( $header eq "04" ) {			##### case INF (Information_Indicator - Fix)
			$inf_ind = hex2bin($1);
			print "\nInformation Indicator\n";
			parse_Ii ($inf_ind);
		}elsif ( $header eq "03" ) {			##### case INR (Information_Request_Indicators - Fix)
			$iri_ind =  hex2bin($1);
			print "\nInformation Request Indicators\n";
			parse_Ir ($iri_ind);
		}
		$param = $5;
		if ($pnt_o eq "00") {print "\nThere are no Optional Param. are present\n"}
		else {parse_param ($param,$lngt,$name)}
	}else{ print "\nCan`t match hex for 2F0 : $param_name{hex2bin($name)}\n"; }
}

######## PARAM_PARSE = clear optional part parse (w/o name & lngt of 1st opt) ###########

sub parse_param {

	while ( $param =~ /(\S{$lngt})(\S{2})\S(\S)/i ) {
		$opt = $1;
		parse_opt_name ($name,$opt);
		$lngt=oct('0x'.$3)*2;
		$name = $2;
		$param = $';
	}
}

############################			      ##############################################
############################ PARAMETERS_SUB_PROCEDURE ##############################################
############################			      ##############################################

##_NAME_PARSE_OPT##

sub parse_opt_name {

	%param_name = ('00101110' => "Access delivery information",
		'00000111' => "Access transport",
		'00100111' => "Automatic congestion level",
		'00010001' => "Backward call indicator",
		'00000001' => "Call reference",
		'00101001' => "Optional backward call indicator",
		'00101010' => "User-to-user indicator",
		'00100000' => "User-to-user information",
		'00100001' => "Connected number",
		'00101100' => "Generic notification",
		'00111001' => "Parameter compatibility information",
		'00101101' => "Call history information",
		'11000000' => "Generic number",
		'00110101' => "Transmission medium used",
		'00110010' => "Remote operations",
		'00001100' => "Redirection number",
		'00010011' => "Redirection information",
		'00110011' => "Service activation",
		'00011101' => "User service information",
		'01000000' => "Redirection number restriction",
		'00101111' => "Network specific facility",
		'00001001' => "Calling party`s category",
		'00001010' => "Calling party number",
		'00000010' => "Transmition medium requirement",
		'00000110' => "Nature of connection indicators",
		'00000111' => "Forward Call Indicator",
		'00001110' => "Information request indicators",
		'00100011' => "Transmition network selection",
		'00001000' => "Optional forward call indicator",
		'00001011' => "Redirecting number",
		'00011010' => "Closed user group interlock code",
		'00001101' => "Connection request",
		'00101000' => "Original called number",
		'00101011' => "Originating ISC point code",
		'00110001' => "Propagation delay counter",
		'00110000' => "User service information prime",
		'11000001' => "Generic digits",
		'00110100' => "User teleservice information",
		'00110010' => "Remoute operations",
#		'00111010' => "Generic reference FSS",
		'00111010' => "MLPP precedence",
		'00111110' => "Transmition medium requirement prime",
		'00111111' => "Location number",
		'01000001' => "Freephone indicators",

		'00110110' => "Call diversion information",
		'00000100' => "Called party number",
		'00100110' => "Ciruit state indicator",
		'00010010' => "Cause indicators",
		'00010101' => "Circuit group supervision msg type indicator",
		'00010000' => "Continuity indicators",
		'00110111' => "Echo control information",
		'00100100' => "Event information",
		'00011000' => "Facility indicator",
		'00111010' => "Generic reference (reserved)",
		'00111101' => "Hop counter",
		'00001111' => "Information indicators",
		'00111011' => "MCID request indicator",
		'00111100' => "MCID response indicator",
		'00111000' => "Message compatibility information",
		'00010110' => "Range and status",
		'00011110' => "Signalling point code",
		'00000101' => "Subsequent number",
		'00100010' => "Suspend/resume indicator",
		'00000000' => "End of optional parameters"
		);

	print "\n$param_name{hex2bin($name)}";

	if ($name eq "11"){						######Backward call indicator
	$bci = hex2bin($opt);
	parse_BCI ($bci);
	}elsif($name eq "29"){						######Optional Backward call indicat
		$obci =  hex2bin($opt);
		parse_OBCI ($obci);
	}elsif($name eq "08"){						######Optional Forward call indicat
		$ofci =  hex2bin($opt);
		parse_OFCI($ofci);
	}elsif($name eq "01"){						######Call reference
		print "Is not supported";
	}elsif($name eq "2A"){						######User-to-user indicators
		$uuind = hex2bin($opt);
		parse_UUInd ($uuind);
	}elsif($name eq "20"){						######User-to-user information
		print "\tUnder construction\n";	### Q.931 section 4.5.29
	}elsif($name eq "07"){						######Access transport
		print "\tUnder construction\n";
	}elsif($name eq "2E"){						######Access delivery information
		$adi = hex2bin($opt);
		parse_ADI($adi);
	}elsif($name eq "2C"){						######Generic notification
		$gni = hex2bin($opt);
		parse_GNI ($gni);
	}elsif($name eq "39"){						######Parameter compatibility inform
		$pcinf = hex2bin($opt);
		parse_PCINF($pcinf);
	}elsif($name eq "2D"){						######Call history information
		$hist = hex2bin($opt);
		parse_History ($hist);
	}elsif($name eq "C0"){						######Generic number
		$gennum = hex2bin($opt);
		parse_GenNum ($gennum);
	}elsif($name eq "35"){						######Transmission medium used
		print "\tUnder construction\n";
	}elsif($name eq "2F"){						######Network specific facility
		print "\tNetwork specific facility is not supported\n";
	}elsif($name eq "32"){						######Remote operations
		print "\tUnder construction\n";
	}elsif($name eq "33"){						######Service activation
		print "\tUder construction\n";
	}elsif($name eq "1D"){						######User service information
		print "\tUnder construction\n";	
	}elsif($name eq "0A" || $name eq "0B" || $name eq "21" || $name eq "28"){
	######Calling party number || Redirecting number || Connected number || Original called number
		$hex_string = $opt;
		parse_CPN_CN ($hex_string);
	}elsif($name eq "09"){						######Calling Party`s category
		$cpc = hex2bin($opt);
		parse_CallingPartCtgr ($cpc);
	}elsif($name eq "02"){						######Transmition medium requirement
		$tmr = hex2bin($opt);
		parse_TMR ($tmr);
	}elsif($name eq "06"){						######Nature of connection indicators
		$nci = hex2bin($opt);
		parse_NCI ($nci);
	}elsif($name eq "07"){						######Forward Call Indicator
		$fci = hex2bin($opt);
		parse_FCI ($fci);
	}elsif($name eq "03"){						######Information request indicators
		$iri_ind = hex2bin($opt);
		parse_Ir ($iri_ind);
	}elsif($name eq "23"){						######Transit network selection
		print "\tIs not supported\n";
	}elsif($name eq "13"){						######Redirection information
		$redinf = hex2bin($opt);
		parse_REDINF($redinf);
	}elsif($name eq "40"){						######Redirection number restriction
		print "\tUnder construction\n";
	}elsif($name eq "1A"){						######Closed user group interlock code
		$cug_ic=hex2bin($opt);
		parse_CUGIC($cug_ic);
	}elsif($name eq "0D"){						######Connection request
		print "\tIs not supported\n";
	}elsif($name eq "31"){						######Propagation delay counter
		$pdc=hex2bin($opt);
		parse_PDC($pdc);
	}elsif($name eq "30"){						######User service information prime
		print "\tUnder construction\n";
	}elsif($name eq "C1"){						######Generic digits
		print "\tIs not supported\n";
	}elsif($name eq "2B"){						######Originating ISC point code
		print "\tUnder construction\n";
	}elsif($name eq "34"){						######User teleservice information
		print "\tUnder construction\n";
	}elsif($name eq "32"){						######Remoute operations
		print "\tIs not supported\n";
	}elsif($name eq "33"){						######Service activation
		print "\tIs not supported\n";
	}elsif($name eq "3A"){						######MLPP precedence
		print "\tUnder construction\n";
	}elsif($name eq "3E"){						######Transmition medium requirement prime
		print "\tUnder construction\n";
	}elsif($name eq "3F"){						######Location number
		print "\tUnder construction\n";
	}elsif($name eq "41"){						######Freephone indicators
		print "\tUnder construction\n";
	}elsif($name eq "36"){						######Call diversion information
		$cdi=hex2bin($opt);
		parse_CDI ($cdi);
	}elsif($name eq "04" || $name eq "0C"){				######Called party number
		$cdpn = $opt;
		parse_CDPN ($cdpn);
	}elsif($name eq "26"){						######Ciruit state indicator
		print "\tIs not supported\n";
	}elsif($name eq "12"){						######Cause indicators
		$cause_ind = hex2bin($opt);
		parse_CAUSE ($cause_ind);
	}elsif($name eq "15"){						######Circuit group supervision msg type indicator
		print "\tUnder construction\n";
	}elsif($name eq "10"){						######Continuity indicators
		print "\tUnder construction\n";
	}elsif($name eq "37"){						######Echo control information
		print "\tUnder construction\n";
	}elsif($name eq "24"){						######Event information
		$evind = hex2bin($opt);
		parse_EVIND($evind);
	}elsif($name eq "18"){						######Facility indicator
		print "\tUnder construction\n";
	}elsif($name eq "3A"){						######Generic reference (reserved)
		print "\tUnder construction\n";
	}elsif($name eq "3D"){						######Hop counter (reserved)
		print "\tReserved\n";
	}elsif($name eq "0F"){						######Information indicators
		$inf_ind = hex2bin($opt);
		parse_Ii($inf_ind);
	}elsif($name eq "3B"){						######MCID request indicator
		print "\tUnder construction\n";
	}elsif($name eq "3C"){						######MCID response indicator
		print "\tUnder construction\n";
	}elsif($name eq "38"){						######Message compatibility information
		print "\tUnder construction\n";
	}elsif($name eq "16"){						######Range and status
		print "\tUnder construction\n";
	}elsif($name eq "1E"){						######Signalling point code
		print "\tIs not supported\n";
	}elsif($name eq "05"){						######Subsequent number
		print "\tUnder construction\n";
	}elsif($name eq "22"){						######Suspend/resume indicators
		$sus = hex2bin($opt);
		parse_SRI($sus);
	}elsif($name eq "00"){						######End of optional parameters
	print "\nEnd of Optional parameters\n";
	}else { print "\nUnknown Optional parameter" }
}

########################################################################
####_Backward Call Indicator(HG)(FE)(DC)(BA) (PO)(N)(M)(L)(K)(J)(I)_####

sub parse_BCI {

	%chin = ('00' => "no indicator",			#Charge indicator
		'01' => "no charge",
		'10' => "charge",
		'11' => "spare");
	%cpsi = ('00' => "no indicator",			#Called party`s status indicator
		'01' => "subscriber free",
		'10' => "reserved (connect when free)",
		'11' => "spare");
	%cpci = ('00' => "no indicator",			#Called party`s category indicator
		'01' => "ordinary subscriber",
		'10' => "payphone");
								#End to end method indicator
	%endm = ('00' => "no End-to-end method available (only link-by-link)",
		'01' => "reserved (pass along)",
		'10' => "reserved (SCCP)",
		'11' => "reserved (pass along and SCCP)");
	%ii = ('0' => "no interworking encountered",		#Interworking indicator
		'1' => "interworking encountered");
								#End to end information indicator
	%endi = ('0' => "no end to end information available",
		'1' => "reserved ( end to end information available)");
								#ISDN User Part indicator
	%isdu = ('0' => "ISDN User Part not used all the way",	
		'1' => "ISDN User Part used all the way");
	%hold = ('0' => "holding not request",		#Holding indicator
		'1' => "holding request");
	%isda = ('0' => "terminating access non-ISDN",	#ISDN access indicator
		'1' => "terminating access ISDN");
								#Echo control device idicator
	%echo = ('0' => "incoming half echo control device not included",
		'1' => "incoming half echo control device included");
								# SCCP method indicator
	%sccp = ('00' => " no indicator",
		'01' => "reserved (connectionless method available)",
		'10' => "reserved (connection oriented method available)",
		'11' => "reserved (connectionless and connection oriented method available");

	if ($bci =~ /(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(\d)(\d)(\d)(\d)(\d)(\d)/i) {
		print "\n\tCharge indicator : $chin{$4}\n";
		print "\tCalled party's status indicator : $cpsi{$3}\n";
		print "\tCalled party's category indicator : $cpci{$2}\n";
		print "\tEnd-to-end method indicator : $endm{$1}\n";
		print "\tInterworking indicator : $ii{$11}\n";
		print "\tEnd-to-end information indicator : $endi{$10}\n";
		print "\tISDN User Part indicator : $isdu{$9}\n";
		print "\tHolding indicator : $hold{$8}\n";
		print "\tISDN access indicator : $isda{$7}\n";
		print "\tEcho control device indicator : $echo{$6}\n";
		print "\tSCCP method indicator : $sccp{$5}\n";
	}else{ print "\nCan`t match BCI-bin\n" }
}

########_Optional_Backward_ Call_Indicator_E-H(D)(C)(B)(A)##################################################################

sub parse_OBCI {

	my %band = ('0' => "no indicator",			#In-band information indicator
		'1' => "in-band information or an appropriate pattern is now available");
	my %div = ('0' => "no-indication",			#Call diversion may occur indicator
		'1' => "call diversion may occur");	
	my %segm = ('0' => "no additional information will be sent",  #Simple segmentation indicator
		'1' => "additional information will be sent in segmentation message"); 
	my %mlpp = ('0' => "no indicator",			#MLPP user indicator
		'1' => "reserved (MLPP user)");

	if ($obci =~ /\d{4}(\d)(\d)(\d)(\d)/i) {
		print "\n\tIn-band information indicator : $band{$4}\n";
		print "\tCall diversion may occur indicator : $div{$3}\n";
		print "\tSimple segmentation indicator : $segm{$2}\n";
		print "\tMLPP user indicator : $mlpp{$1}\n";
	}
}

####################_User-to-user_indicators_(H)(GF)(ED)(CB)(A)_##############################################################

sub parse_UUInd {

	my %request_13 = ('00' => "no ifromation",			###Request_Services 1,3
			'01' => "spare",
			'10' => "reserved (request, not essential)",
			'11' => "reserved (request, essential)" );
	my %request_2 = ('00' => "no ifromation",			###Request_Service  2
			'01' => "spare",
			'10' => "request, not essential",
			'11' => "request, essential");
	my %response_13 = ('00' => "no ifromation",			###Response_Services 1,3
			'01' => "reserved (not provided)",
			'10' => "reserved (provided)",
			'11' => "spare");
	my %response_2 = ('00' => "no ifromation",			###Response_Service  2
			'01' => "not provided",
			'10' => "provided",
			'11' => "spare");
	my %ndi = 	('0' => "no ifromation",			###Network_discard_ind
			'1' => "user-to-user information discarded by the network");

	if ( $uuind =~ /(\d)(\d\d)(\d\d)(\d\d)(\d)/i ) {
		my $type = $5;
		$request_2="";
		$response_2="";
		if ($type eq "0") {
			print "\tRequset Service 1 : $request_13{$4}\n";
			print "\tRequset Service 2 : $request_2 {$3}\n";
			print "\tRequset Service 3 : $request_13{$2}\n";
		}elsif ($type eq "1") {
			print "\tResponse Service 1 : $response_13{$4}\n";
			print "\tResponse Service 2 : $response_2 {$3}\n";
			print "\tResponse Service 3 : $response_13{$2}\n";
			print "\tNetwork discard ind: $ndi{$1}\n";
		}
	}
}

######Call history information 
sub parse_History {
	if ($hist =~ /(\d{8})(\d{8})/i) { print "\t$1 $2\n\n"}
}
######## Parameter compatibility inform : (Upgraded param 8)(ext 1)(GF 2)(E 1)(D 1)(C 1)(B 1)(A 1) #######

sub parse_PCINF {

	my %trans = ('0' => "transit interpretation",		## A-bit
		'1' => "end node interpretation");
	my %relci = ('0' => "do not release call",		## B-bit
		'1' => "release call");
	my %sni = ('0' => "do not send notification",		## C-bit
		'1' => "send notification");
	my %dmi = ('0' => "do not discard message (pass on)",	## D-bit
		'1' => "discard message");
	my %dpi = ('0' => "do not discard parameter (pass on)",	## E-bit
		'1' => "discard parameter");
	my %pass = ('00' => "release call",
		'01' => "discard message",
		'10' => "discard parameter",
		'11' => "reserved");

	if ($pcinf =~ /(\d{8})(\d)(\d{2})(\d)(\d)(\d)(\d)(\d)/i) {
		print "\nUpgraded parameter : $param_name{$1}\n";
		print "Instraction indicator \n";
		print "\tTransit at intermediate exchange indicator : $trans{$8}\n";
		print "\tRelease call indicator : $relci{$7}\n";
		print "\tSend notification indicator : $sni{$6}\n";
		print "\tDiscard message indicator : $dmi{$5}\n";
		print "\tDiscard parameter indicator : $dpi{$4}\n";
		print "\tPass or not possible indicator : $pass{$3} (spare)\n";
		if ($2 eq "0") { print "\n\n\tMore Instruction indicators will be defined when requred\n"}
	}else{ print "Can`t match Parameter compatibility inform" }
}

######## Information indicators ###

sub parse_Ii {
	
	my %cpari = ('00' => "calling party address not included",	### BA
		'01' => "calling party address not avalible",
		'10' => "spare",
		'11' => "calling party address included");
	my %hpi = ('0' => "hold not provided",				### C
		'1' => "hold provided");
	my %cpcri = ('0' => "calling party category not included",	### F
		'1' => "calling party category included");
	my %chiri = ('0' => "charge information not included",		### G
		'1' => "reserved (charge information included)");
	my %sii	= ('0' => "solicited",					### H
		'1' => "reserved (unsolicided)");
	my %mciri = ('0' => "malicious call identification not provided", ### D
		'1' => "malicious call identification provided");

	if ( $inf_ind =~ /(\d)(\d)(\d)\d(\d)(\d)(\d\d)\d{8}/) {
		print "\tCalling party address response indicator : $cpari{$6}\n";
		print "\tHold provided indicator : $hpi{$5}\n";
		print "\tMCID : $mciri{$4}\n";
		print "\tCalling party category response indicator : $cpcri{$3}\n";
		print "\tCharge information response indicator : $chiri{$2}\n";
		print "\tSolicited information indicator : $sii{$1}\n";
	}else{print "\nCan`t match Information indicators in INF\n"}
}

############# Calling party`s category #############

sub parse_CallingPartCtgr {

	my %cpcf = ('00000000' => "calling party`s category unknown at this time",
		'00000001' => "reserved (operator, language French )",
		'00000010' => "reserved (operator, language English)",
		'00000011' => "reserved (operator, language German)",
		'00000100' => "reserved (operator, language Russian)",
		'00000101' => "reserved (operator, language Spanish)",
		'00000110'=>"reserved (available to administrations for selecting a particular language by mutual agreement)",
		'00000111'=>"reserved (available to administrations for selecting a particular language by mutual agreement)",
		'00001000'=>"reserved (available to administrations for selecting a particular language by mutual agreement)",
		'00001001' => "national operator with offer fucility",
		'00001010' => "ordinary calling subscriber",
		'00001011' => "calling subscriber with priority",
		'00001100' => "data call (voice band data)",
		'00001101' => "test call",
		'00001110' => "spare",
		'00001111' => "payphone",
		'11100000' => "reserved for national use",
		'11100001' => "calling subscriber with home metering or advice of charge",
		'11100010' => "calling subs. with (remote) immediate charge indicator",
		'11100011' => "interception operator");

	if ($cpc =~ /(\d{8})/i) {
		print "\n\nCalling party`s category : $cpcf{$1}";
	}else{print "\n\nCan`t match Calling party`s category (bin)\n\n"}
}

####### Calling Party Number ########

sub parse_CPN_CN {

	%ni = ('0' => "complete",
	     '1' => "incomplete");
	%apr = ('00' => "presentation allowed",
	     '01' => "presentation restricted",
	     '10' => "address not available",
	     '11' => "spare");
	%scr = ('00' => "reserved",
		'01' => "user provided, verified and passed",
		'10' => "reserved",
		'11' => "network provided");

	if ($hex_string =~ /(\S{4})(\S*)/i){
		$cpn=hex2bin("$1");
		$na ="$2";
	}else{print "\nCan`t match hex for Clng Prt Nmb\n"}
	if ( $cpn =~ /(\d)(\d{7})(\d)(\d{3})(\d\d)(\d\d)/i ) {
		print "\n\tNature of address indicator : $nai{$2}\n\t";
		if($name eq "0A"){print "Calling party number incomplete indicator (NI) : $ni{$3}\n\t"}
		print "Numbering plan indicator : $npi{$4}\n\t";
		print "Address presentation restricted indicator : $apr{$5}\n\t";
		if($name eq "0A" || $name eq "21"){print "Screening indicator : $scr{$6}"}
		$odd=$1;
	}else{print "\n\nCan`t match Calling party number (bin)\n\n$cpn"}
	if ($na =~ /(\S)(\S)(\S)(\S)(\S)(\S)(\S)(\S)(\S)(\S)/i ) {
		if ($odd eq "0"){print "\n\tAddress A : $2$1$4$3$6$5$8$7$9"}
		else{print "\n\tAddress A : $2$1$4$3$6$5$8$7$10\n"}
	}else{print "\n\n\tAddress A is omitted\n\n"}
}

######## Called Party Number ########

sub parse_CDPN {

	%nai = ('0000000' => "spare",
	     '0000001' => "subscriber number (AC=1-0)",
	     '0000010' => "unknown (AC=2-0)",
	     '0000011' => "national (significant) number (AC=3-0)",
	     '0000100' => "international number (AC=4-0)");
	%inn = ('0' => "routing to internal network number allowed",
	     '1' => "routing to internal network number not allowed");
	%npi = ('000' => "spare",
	     '001' => "ISDN (Telephony) numbering plan (Recommendation E.164)",
	     '010' => "spare",
	     '011' => "reserved (Data numbering plan (Rec. X.121))",
	     '100' => "reserved (Telex numbering plan (Rec. F.69))",
	     '101' => "reserved for national use",
	     '110' => "reserved for national use",
	     '111' => "spare");

	sub reverse_nd {
		($nb) = @_;
		my $rnb = "";
		while ($nb =~ /^(\S)(\S)/) {
			$rnb .= $2.$1;
			$nb = $';
		}
		$rnb .= $nb;
		$rnb =~ s/F$//i;
		return $rnb;
	}
	if ($cdpn =~ /(\S{4})(\S+)/i) {				####nai_inn_npi:2b+NB
		$head_nb=hex2bin($1);
		$nb=$2;
	}else{print "\n\nCan`t match Called party number (hex)\n\n"}
	if ($head_nb =~ /\d(\d{7})(\d)(\d{3})\d{4}/) {
		if ($header eq "01") {print "\n\nCalled party number \n\t"} else {print "\n\t"}
		print "Nature of address indicator : $nai{$1}\n\t";
		print "Internal network number indicator (INN ind) : $inn{$2}\n\t";
		print "Numbering plan indicator : $npi{$3}";
	}else{print "\n\nCan`t match Called party number (bin)\n\n"}
	print "\n\tAddress B : ".reverse_nd($nb)."\n";
}

######## Information request indicator ######

sub parse_Ir {

	my %cari = ( '0' => "calling party address not requested",			### A
		'1' => "calling party address requested" );
	my %hi = ( '0' => "holding not request",					### B
		'1' => "holding not request" );
	my %cpcri = ( '0' => "calling party category not requested",			### D
		'1' => "calling party category requested" );
	my %ciri = ( '0' => "charge information not requested",				### E
		'1' => "reserved (charge information requested)" );
	my %mcid = ( '0' => "malicious call identification not requested",		### H
		'1' => "reserved for malicious call identification requested");

	if ( $iri_ind =~ /(\d)\d{2}(\d)(\d)\d(\d)(\d)\d{8}/i ) {
		print"\tCalling party address request indicator : $cari{$5}\n";
		print"\tHolding indicator : $hi{$4}\n";
		print"\tCalling party category request indicator : $cpcri{$3}\n";
		print"\tCharge information request indicator : $ciri{$2}\n";
		print"\tMalicious call identification request indicator : $mcid{$1}\n";
	}else{print "\n\nCan`t match Iri"}
}

############# Nature of connection indicators#####

sub parse_NCI {

	my %ecdi = ('0' => "outgoing half echo control device not included",
		'1' => "outgoing half echo control device included");
	my %check = ('00' => "Continuity check not required",
		'01' => "Continuity check required on this circuit",
		'10' => "Continuity check performed on a previous circuit",
		'11' => "spare");
	my %sati = ('00' => "no satellite circuit in the connection",
		'01' => "one satellite circuit in the connection",
		'10' => "two satellite circuit in the connection",
		'11' => "spare");

	if ($nci =~ /\d\d\d(\d)(\d\d)(\d\d)/i){
		print "\nNature of connection indicators \n\t";
		print "Echo control device indicator : $ecdi{$1}\n\t";
		print "Continuity check indicator : $check{$2}\n\t";
		print "Satellite indicator : $sati{$3}";
	}else{print "\n\nCan`t match Nature of connection indicators (bin)\n\n"}
}

####### Forward Call Indicator #######

sub parse_FCI {

	my %upri = ('00' => "ISDN User Part preferred all the way",
		'01' => "ISDN User Part not required all the way",
		'10' => "ISDN User Part required all the way",
		'11' => "spare");
	my %isup = ('0' => "ISDN User Part not used all the way",
		'1' => "ISDN User Part used all the way");
	my %intw = ('0' => "no interworking encountered (No.7 signalling all the way)",
		'1' => "interworking encountered");
	my %etei =('0' => "no end-to-end information available",
		'1' => "reserved (end-to-end information available)");
	my %etem = ('00' => "no end-to-end method available",
		'01' => "reserved (pass along method available)",
		'10' => "reserved (SCCP method available)",
		'11' => "reserved (pass along and SCCP method available)");
	my %nici = ('0' => "call to be treated as a national call",
		'1' => "call to be treated as a international call");
	my %iai = ('0' => "originating access non-ISDN",
		'1' => "originating access ISDN");

       if ($fci =~ /(\d\d)(\d)(\d)(\d)(\d\d)(\d)\d{7}(\d)/i){
               print "\n\nForward call indicator \n\t";
               print "ISDN User Part preference indicator : $upri{$1}\n\t";
               print "ISDN User Part indicator : $isup{$2}\n\t";
               print "End-to-end information indicator : $etei{$3}\n\t";
               print "Interworking indicator : $intw{$4}\n\t";
               print "End-to-end method indicator : $etem{$5}\n\t";
               print "National/International call indicator : $nici{$6}\n\t";
               print "ISDN access indicator : $iai{$7}";
       }else{print "\n\nCan`t match Forward call indicators (bin)\n\n"}
}

############## Transmition medium requirement (TMR) ############

sub parse_TMR {

	my %tmrf = ('00000000' => "speech",
		'00000001' => "spare",
		'00000010' => "64 Kbit/s unrestricted",
		'00000011' => "3.1 kHz audio",
		'00000100' => "reserved for alternate speech (service 2)/64 Kbit/s unrestricted (service 1)",
		'00000101' => "reserved for alternate 64 Kbit/s (service 1)/speech (service 2)",
		'00000110' => "reserved (64 Kbit/s preferred)",
		'00000111' => "reserved (2x64 Kbit/s unrestricted)",
		'00001000' => "reserved (384 Kbit/s unrestricted)",
		'00001001' => "reserved (1536 Kbit/s unrestricted)",
		'00001010' => "reserved (1920 Kbit/s unrestricted)");
	if ($tmr =~ /(\d{8})/i) {
		print "\n\nTransmition medium requirement (TMR) : $tmrf{$1}"; 
	}else{print "\n\nCan`t match Transmition medium requirement (bin)\n\n"}
}

############ Cause Indicators #######################################

sub parse_CAUSE {


	my %cs = ('00' => "CCITT standardized coding",
		'01' => "ISO/IEC standard",
		'10' => " national standard",
		'11' => "standard specific to identified location");
	my %location = ('0000' => "user (U)",
		'0001' => "private network serving the local user (LPN)",
		'0010' => "public network serving the local user (LN)",
		'0011' => "transit network (TN)",
		'0100' => "public network serving the remote user (RLN)",
		'0101' => "private network serving the remote user (RPN)",
		'0111' => " international network (INTL)",
		'1010' => "network beyond interworking point (BI)");
	my %c_value = ('0000001' => "Normal event - Unassigned number\t( 0x1 ; 1 )",
		'0000010' => "Normal event - No route to specified transit network\t( 0x2 ; 2 )",
		'0000011' => "Normal event - No route to destination (Transit network identity)\t( 0x3 ; 3 )",
		'0000110' => "Normal event - Channel unacceptable\t( 0x6 ; 6 )",
		'0000111' => "Normal event - Call awarded and being delivered in an established channel\t( 0x7 ; 7 )",
		'0010000' => "Normal event - Normal call clearing\t( 0x10 ; 16 )",
		'0010001' => "Normal event - User busy\t( 0x11 ; 17 )",
		'0010010' => "Normal event - No user responding\t( 0x12 ; 18 )",
		'0010011' => "Normal event - No answer from user (user alerted)\t( 0x13 ; 19 )",
		'0010101' => "Normal event - Call rejected (User Supplied diagnostic)\t( 0x15 ; 21 )",
		'0010110' => "Normal event - Number changed (New destination)\t( 0x16 ; 22 )",
		'0011010' => "Normal event - Non-selected user clearing\t( 0x1A ; 26 )",
		'0011011' => "Normal event - Destination out of order\t( 0x1B ; 27 )",
		'0011100' => "Normal event - Invalid number format (Facility identification)\t( 0x1C ; 28 )",
		'0011101' => "Normal event - Facility rejected\t( 0x1D ; 29 )",
		'0011110' => "Normal event - Respons to STATUS ENQUIRY\t( 0x1E ; 30 )",
		'0011111' => "Normal event - Normal unspecified\t( 0x1F ; 31 )",
		'0100010' => "Resourse unavailable - No circuit/channel available\t( 0x22 ; 34 )",
		'0100110' => "Resourse unavailable - Network out of order\t( 0x26 ; 38 )",
		'0101001' => "Resourse unavailable - Temporary failure\t( 0x29 ; 41)",
		'0101010' => "Resourse unavailable - Switching equipment congestion\t( 0x2A ; 42 )",
		'0101011' => "Resourse unavailable - Access information discarded (Discarded IE identifier(s)\t( 0x2B ; 43 )",
		'0101100' => "Resourse unavailable - Requested circuit/chan not available\t( 0x2C ; 44 )",
		'0101111' => "Resourse unavailable - Resources unavailable, unspecified\t( 0x2F ; 47 )",
		'0110001' => "Service/option not avialab - Quality of service unavailable\t( 0x31 ; 49 )",
		'0110010' => "Service/option not avialab - Requested facility not subscribed (Facility identification)\t( 0x32 ; 50 )",
		'0111001' => "Service/option not avialab - Bearer capability not authorized\t( 0x39 ; 57 )",
		'0111010' => "Service/option not avialab - Bearer capability not presently avail\t( 0x3A ; 58 )",
		'0111111' => "Service/option not avialab - Service or option not available\t( 0x3F ; 63 )",
		'1000001' => "Service/option not implem - Bearer capability not implementation (Channel type)\t( 0x41 ; 65 )",
		'1000010' => "Service/option not implem - Channel type not implemented (Facility identification)\t( 0x42 ; 66 )",
		'1000101' => "Service/option not implem - Requested facility not implemented\t( 0x45 ; 69 )",
		'1000110' => "Service/option not implem - Only restr. Dig. Info BC. Is available\t( 0x46 ; 70 )",
		'1001111' => "Service/option not implem - Service or option not implemented\t( 0x4F ; 79 )",
		'1010001' => "Invalid message - Invalid call reference value (Channel identity)\t( 0x51 ; 81 )",
		'1010010' => "Invalid message - Identified channel does not exist\t( 0x52 ; 82 )",
		'1010011' => "Invalid message - Call id does not exist for susp call\t( 0x53 ; 83 )",
		'1010100' => "Invalid message - Call identity in use\t( 0x54 ; 84 )",
		'1010101' => "Invalid message - No call suspended (Clearing cause Incompatible parameter)\t( 0x55 ; 85 )",
		'1010110' => "Invalid message - Call with the req call id is cleared\t( 0x56 ; 86 )",
		'1011000' => "Invalid message - Incompatible destination\t( 0x58 ; 88 )",
		'1011011' => "Invalid message - Invalid transit netwoerk selection\t( 0x5B ; 91 )",
		'1011111' => "Invalid message - Invalid message unspecified\t( 0x5F ; 95 )");

	if ($cause_ind =~ /\d(\d\d)0(\d{4})1(\d{7})/i) {
		my $fucking_cvalue;
		if ($c_value{$3}) { $fucking_cvalue = $c_value{$3} } else { $fucking_cvalue = "Reserved"; }
		print "\n\tCoding standard : $cs{$1}\n\t";
		print "Location : $location{$2}\n\t";
		print "Cause value : $fucking_cvalue\n";
	}else{print "Can`t match Cause Indicator (bin)"}
}

############# Propagation delay counter ##################
sub parse_PDC {

	if ($pdc =~ /(\d{8})(\d{8})/i) { print "\t$1 $2\n" }
}
######## Event information ###############################

sub parse_EVIND {

	my %evinf = ('0000001' => "ALERTING",
		'0000010' => "PROGRESS",
		'0000011' => "in-band information or an appropriate pattern is now available",
		'0000100' => "call forwarded on busy",
		'0000101' => "call forwarded on no reply",
		'0000110' => "call forwarded unconditional");

	if ($evind =~ /(\d)(\d{7})/i) {
		if ($1 eq "0") {print "\tEvent presentation restricted indicator : no indication\n"}
		elsif ($1 eq "1") {print "\tEvent presentation restricted indicator : presentation restricted\n"}
		print "\tEvent indicator : $evinf{$2}\n";
	}else {print "\n\nCan`t match Event indicator (bin)\n"}
}

####### Suspend/resume indicators #########################

sub parse_SRI {

	my %sri = ('0' => "ISDN subscriber initiated",
	'1' => "network initiated");

	if ($sus =~ /\d{7}(\d)/i){
		print "\n\tSuspend / resume indicator : $sri{$1}\n";
	}else{ print "Can`t match SUS-hex" }
}

####### Optional forwward call indicator ##################

sub parse_OFCI {

	%cugci = ('00' => "non-CUG call",
		'01' => "spare",
		'10' => "closed user group call, O/G access allowed",
		'11' => "closed user group call, O/G access not allowed");

	%ssi = ('0' => "no additional information will be sent",
		'1' => "additional information will be sent in a segmentation message");

	%cliri = ('0' => "not requested",
		'1' => "requested");

	if ( $ofci =~ /(\d)\d{4}(\d)(\d{2])/i ) {
		print "\n\tClosed user group indicator : $cugci{$3}";
		print "\n\tSimple segmentation indicator : $ssi{$2}";
		print "\n\tConnected line request indicator : $cliri{$1}";
	}
}

######### Redirection infromation ############################

sub parse_REDINF {

	%redind = ('000' => "no redirection",								### CBA
		'001' => "call rerouted",
		'010' => "call rerouted, all redirection information presentation restricted",
		'011' => "call diversion",
		'100' => "call diversion, all redirection information presentation restricted",
		'101' => "call rerouted, redirection number presentation restricted",
		'110' => "call diversion, redirection number presentation restricted");

	%orr = ('0000' => "unknown / not avalible",							### HGFE
		'0001' => "user busy",
		'0010' => "no reply",
		'0011' => "unconditional");

	%redrsn = ('0000' => "unknown / not avalible",							### PONM
		'0001' => "user busy",
		'0010' => "no reply",
		'0011' => "unconditional",
		'0100' => "deflection during allerting",
		'0101' => "deflection immediate response",
		'0110' => "mobile subscriber not reachable");

	if ( $redinf =~ /(\d{4})\d(\d{3})(\d{4})\d(\d{3})/i ) {
		if($redind{$4}){print "\n\tRedirecting indicator : $redind{$4}"}
		else {print "\n\tRedirecting indicator : spare"}
		if($orr{$3}){print "\n\tOriginal redirection reasons : $orr{$3}"} 
		else {print "\n\tOriginal redirection reasons : spare"}
		print "\n\tRedirection counter : $2";
		if($redrsn{$1}){print "\n\tRedirecting reason : $redrsn{$1}"}
		else {print "\n\tRedirecting reason : spare"}
	}
}

########## Closed User Group interlock code ###################

sub parse_CUGIC {
	
	if ( $cug_ic =~ /(\d{8})(\d{8})(\d{4})(\d{4})(\d{4})(\d{4})/ ) {
		print "\nNetwork identity (NI)\n";
		my $ni1=oct('0b'.$5);
		print "\n\t1st NI digit : $ni1";
		my $ni2=oct('0b'.$6);
		print "\n\t2nd NI digit : $ni2";
		my $ni3=oct('0b'.$3);
		print "\n\t3rd NI digit : $ni3";
		my $ni4=oct('0b'.$4);
		print "\n\t4th NI digit : $ni4\n";
		print "\nBinary code : $5 $6\n";
	}else{print "Can`t match CUG_IC (bin)"}
}

###### Generic number ############################################

sub parse_GenNum {

	%nqi = ('00000000' => "reserved (dialled digits)",
		'00000001' => "additional called number",
		'00000010' => "reserved (suplemental user provided calling number - falled network screening)",
		'00000011' => "reserved (suplemental user provided calling number - not screened)",
		'00000100' => "reserved (redirecting terminating number)",
		'00000101' => "additional connected number",
		'00000110' => "additional calling party number",
		'00000111' => "additional original called number",
		'00001000' => "additional redirecting number",
		'00001001' => "additional redirection number",
		'00001010' => "reserved (called freephone number)");

	if ( $gennum = ~/(\d{8})(\d{16})(\d*)/) {
		print "\n\tNumber qualifier indicator : $nqi{$1}\n";
		$cpn=$2;
		$na=$3;
		parse_CPN_CN($cpn,$na);
	}
}

####### Call diversion information ################################

sub parse_CDI {

	%nso = ('000' => "Unknown",
		'001' => "presentation not allowed",
		'010' => "presentation allowed with redirection number",
		'100' => "presentation not allowed without redirection number");

	if ( $cdi =~ /(\d{3})(\d{4})/ ) {
		if($nso{$1}) {print "\n\tNotification subscription options : $nso{$1}"}
		else{print"\n\tNotification subscription options : Spare"}
		if($redrsn{$2}) {print "\n\tRedirection reason : $redrsn{$2}\n"}
		else{print"\n\tRedirection reason : Spare\n"}
	}else{print "\n\nCan`t match CDI\n\n"}
}

###### Generic notification indicator ###################################

sub parse_GNI {

	%gni_ni = ('0000000' => "user suspended",
		'0000001' => "user resumed",
		'0000010' => "bearer service change (used in DSS1)",
		'0000011' => "discriminator for extension to ASN.1 encoded component",
		'0000100' => "call completion delay",
		'1000010' => "conference established",
		'1000011' => "conference disconected",
		'1000100' => "other party added",
		'1000101' => "isolated",
		'1000110' => "reattached",
		'1000111' => "other party isolated",
		'1001000' => "other party reattached",
		'1001001' => "other party split",
		'1001010' => "other party disconected",
		'1001011' => "conference floating",
		'1100000' => "call is a waiting call",
		'1101000' => "diversion activated used in DSS1",
		'1101001' => "call transfer, allerting",
		'1101010' => "call transfer, active",
		'1111001' => "remote hold",
		'1111010' => "remote retrieval",
		'1111011' => "call is diverting");

	if ( $gni =~ /\d(\d{7})/ ) {print "\n\tNotification indicator : $gni_ni{$1}\n"}
	else{"\n\nCan`t match GNI\n\n"}
}

######## Access Delivary Information ########################################

sub parse_ADI {

	print "\tUnder construction\n$adi";
	if ( $adi =~ /\d{6}(\d\d)/  ) {


	}

}
