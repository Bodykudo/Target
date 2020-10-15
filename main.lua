for _,v in pairs ({'disableAutoScore','disablePhysicalConsumables','disableAutoNewGame','disableDebugCommand','disableMortCommand','disableMinimalistMode','disableAutoTimeLeft','disableAutoShaman'}) do
	tfm.exec[v](true)
end
tfm.exec.setRoomMaxPlayers(20)

colors={
    [5]="CH",
    [4]="VP",
    [3]="FC",
    [2]="R",
    [1]="ROSE",
    [0]="ROSE"
}

keys={
    [72]="help",
    [80]="profile",
    [76]="leaderboard",
    [79]="shop"
}

buttons={
    help="help",
    leaderboard="leaderboard",
    profile="profile",
    shop="shop"
}

commus={bg="16501fe9900",br="16501feb767",es="16502016f7e",en="16502014e66",e2="16502014e66",ch="16502014e66",az="16502014e66",ee="16502012786",de="16502010d54",cz="1650200f889",cn="1650200dcb8",he="1650201cd14",fr="1650201ae36",fi="16502018f27",hu="1650202c454",hr="16502029140",it="165020300f6",id="1650202ed53",jp="165020338b5",lt="16502035415",lv="16502037161",nl="1650203a27f",pl="16502046783",ph="16502043268",pt="1650204a49f",ro="1650204bfab",ru="1650204f3c4",ar="165020563f3",sk="16502069482",vk="1650206ff15",xx="16502071c3a",tr="1650206d73c"}

id={
    lb={{},{},{},{},{},{},{},{},{},{}},
    shop={{},{},{}}
}

UpdateFileTime=os.time()
started=false
nextMap=1
lastMap=0
t=0
gravity=false
playersNum=0
stop=false
finished=false

target=""
p={}
data={}
ts={}
text={}
translations={}

function close(n)
	for i=2,30 do
		ui.removeTextArea(i,n)
	end
	for i=1,10 do
		if id.lb[i][n] then
			tfm.exec.removeImage(id.lb[i][n],n)
			id.lb[i][n]=nil
		end
	end
end