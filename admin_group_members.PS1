#--------------------------------
#Script will get the members of all the workstation admin groups and output them to
#a CSV file of the following column format
#
#groupname,numberofmembers,memberlist(pipedelimited)
#--------------------------------
Import-Module activedirectory

$groups = get-adgroup -Filter * -SearchBase 'OU=Workstations,OU=Machine Admin Groups,OU=Users & Groups,OU=Enterprise Resources,DC=contoso,DC=com' -ResultSetSize $null -Properties 'info'

del c:\temp\groups.csv -Force -OutVariable $null

foreach ($group in $groups)
{
	$count=0
	$nameofgroup = $group.name
	$groupnotes = $group.info
	
	##$group.members | %{$count++}
	[array]$members=Get-ADGroupMember $group
	
	if ($members.count -gt 0) {
		#$members=Get-ADGroupMember $group
		$memberstring = ""
		foreach ($member in $members) 
		#for ($i=0;$i -lt $members.Count-1;$i++)
		{
			$memberstring = $memberstring + $member.name.ToString() + ' | ' 
		}
		        
		if ($groupnotes -ne $null) {
        $outstring = '"' + $nameofgroup + '","' + $members.Count.tostring() + '",' + '"' + $memberstring + '"' + ',"' + $groupnotes.Replace("`n","") + '"'}
        
        else{$outstring = '"' + $nameofgroup + '","' + $members.count.ToString() + '",' + '"' + $memberstring + '"' + ',"' + $groupnotes + '"'}
	
		Out-File -filePath "c:\temp\groups.csv" -inputObject $outstring -append -encoding ascii
		
	}

	
	
}


