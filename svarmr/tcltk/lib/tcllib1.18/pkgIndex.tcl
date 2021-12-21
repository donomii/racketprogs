# Tcl package index file, version 1.1
# Do NOT edit by hand.  Let tcllib install generate this file.
# Generated by tcllib installer for version 1.18

# All tcllib packages need Tcl 8 (use [namespace])
if {![package vsatisfies [package provide Tcl] 8]} {return}

# Extend the auto_path to make tcllib packages available
if {[lsearch -exact $::auto_path $dir] == -1} {
    lappend ::auto_path $dir
}

# For Tcl 8.3.1 and later, that's all we need
if {[package vsatisfies [package provide Tcl] 8.4]} {return}
if {(0 == [catch {
    package vcompare [info patchlevel] [info patchlevel]
}]) && (
    [package vcompare [info patchlevel] 8.3.1] >= 0
)} {return}

# For older Tcl releases, here are equivalent contents
# of the pkgIndex.tcl files of all the modules

if {![package vsatisfies [package provide Tcl] 8.0]} {return}


set maindir $dir
set dir [file join $maindir aes] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir amazon-s3] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir asn] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir base32] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir base64] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir bee] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir bench] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir bibtex] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir blowfish] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir cache] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir clock] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir cmdline] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir comm] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir control] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir coroutine] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir counter] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir crc] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir cron] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir csv] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir debug] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir defer] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir des] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir dicttool] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir dns] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir docstrip] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir doctools] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir doctools2base] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir doctools2idx] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir doctools2toc] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir dtplite] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir fileutil] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir ftp] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir ftpd] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir fumagic] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir generator] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir gpx] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir grammar_aycock] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir grammar_fa] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir grammar_me] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir grammar_peg] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir hook] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir html] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir htmlparse] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir http] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir httpd] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir httpwget] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir ident] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir imap4] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir inifile] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir interp] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir irc] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir javascript] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir jpeg] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir json] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir lambda] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir ldap] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir log] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir map] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir mapproj] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir markdown] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir math] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir md4] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir md5] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir md5crypt] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir mime] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir multiplexer] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir namespacex] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir ncgi] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir nettool] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir nmea] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir nns] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir nntp] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir ntp] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir oauth] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir oodialect] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir oometa] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir ooutil] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir otp] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir page] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir pki] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir pluginmgr] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir png] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir pop3] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir pop3d] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir practcl] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir processman] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir profiler] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir pt] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir rc4] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir rcs] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir report] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir rest] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir ripemd] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir sasl] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir sha1] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir simulation] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir smtpd] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir snit] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir soundex] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir stooop] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir string] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir stringprep] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir struct] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir tar] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir tepam] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir term] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir textutil] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir tie] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir tiff] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir tool] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir tool_datatype] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir transfer] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir treeql] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir try] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir udpcluster] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir uev] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir units] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir uri] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir uuid] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir valtype] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir virtchannel_base] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir virtchannel_core] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir virtchannel_transform] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir websocket] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir wip] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir yaml] ;	 source [file join $dir pkgIndex.tcl]
set dir [file join $maindir zip] ;	 source [file join $dir pkgIndex.tcl]
unset maindir

