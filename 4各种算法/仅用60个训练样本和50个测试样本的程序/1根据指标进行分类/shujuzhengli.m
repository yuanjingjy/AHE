clc
clear all

load h1_a40439
T0_439=9873;
FW_439=T0_439+60;
h1_439abpmean=ABPMean(T0_439-600:FW_439);
h1_439abpdias=ABPDias(T0_439-600:FW_439);
h1_439hr=HR(T0_439-600:FW_439);
h1_439pulse=PULSE(T0_439-600:FW_439);

load h1_a40493
T0_493=6943;
FW_493=T0_493+60;
h1_493abpmean=ABPMean(T0_493-600:FW_493);
h1_493abpdias=ABPDias(T0_493-600:FW_493);
h1_493hr=HR(T0_493-600:FW_493);
h1_493pulse=PULSE(T0_493-600:FW_493);

load h1_a40764
T0_764=1347;
FW_764=T0_764+60;
h1_764abpmean=ABPMean(T0_764-600:FW_764);
h1_764abpdias=ABPDias(T0_764-600:FW_764);
h1_764hr=HR(T0_764-600:FW_764);
h1_764pulse=PULSE(T0_764-600:FW_764);

load h1_a40834
T0_834=2065;
FW_834=T0_834+60;
h1_834abpmean=ABPMean(T0_834-600:FW_834);
h1_834abpdias=ABPDias(T0_834-600:FW_834);
h1_834hr=HR(T0_834-600:FW_834);
h1_834pulse=PULSE(T0_834-600:FW_834);

load h1_a40928
T0_928=11937;
FW_928=T0_928+60;
h1_928abpmean=ABPMean(T0_928-600:FW_928);
h1_928abpdias=ABPDias(T0_928-600:FW_928);
h1_928hr=HR(T0_928-600:FW_928);
h1_928pulse=PULSE(T0_928-600:FW_928);

load h1_a41200
T0=7349;
h1_1200abpmean=ABPMean(T0-600:T0+60);
h1_1200abpdias=ABPDias(T0-600:T0+60);
h1_1200hr=HR(T0-600:T0+60);
h1_1200pulse=PULSE(T0-600:T0+60);

load h1_a41447
T0=2329;
h1_1447abpmean=ABPMean(T0-600:T0+60);
h1_1447abpdias=ABPDias(T0-600:T0+60);
h1_1447hr=HR(T0-600:T0+60);
h1_1447pulse=PULSE(T0-600:T0+60);

load h1_a41770
T0=6998;
h1_1770abpmean=ABPMean(T0-600:T0+60);
h1_1770abpdias=ABPDias(T0-600:T0+60);
h1_1770hr=HR(T0-600:T0+60);
h1_1770pulse=PULSE(T0-600:T0+60);

load h1_a41835
T0=7104;
h1_1835abpmean=ABPMean(T0-600:T0+60);
h1_1835abpdias=ABPDias(T0-600:T0+60);
h1_1835hr=HR(T0-600:T0+60);
h1_1835pulse=PULSE(T0-600:T0+60);

load h1_a41882
T0=12685;
h1_1882abpmean=ABPMean(T0-600:T0+60);
h1_1882abpdias=ABPDias(T0-600:T0+60);
h1_1882hr=HR(T0-600:T0+60);
h1_1882pulse=PULSE(T0-600:T0+60);

load h1_a41925
T0=3985;
h1_1925abpmean=ABPMean(T0-600:T0+60);
h1_1925abpdias=ABPDias(T0-600:T0+60);
h1_1925hr=HR(T0-600:T0+60);
h1_1925pulse=PULSE(T0-600:T0+60);

load h1_a42277
T0=3796;
h1_2277abpmean=ABPMean(T0-600:T0+60);
h1_2277abpdias=ABPDias(T0-600:T0+60);
h1_2277hr=HR(T0-600:T0+60);
h1_2277pulse=PULSE(T0-600:T0+60);

load h1_a42397
T0=6786;
h1_2397abpmean=ABPMean(T0-600:T0+60);
h1_2397abpdias=ABPDias(T0-600:T0+60);
h1_2397hr=HR(T0-600:T0+60);
h1_2397pulse=PULSE(T0-600:T0+60);

load h1_a42410
T0=2361;
h1_2410abpmean=ABPMean(T0-600:T0+60);
h1_2410abpdias=ABPDias(T0-600:T0+60);
h1_2410hr=HR(T0-600:T0+60);
h1_2410pulse=PULSE(T0-600:T0+60);

load h1_a42928
T0=1171;
h1_2928abpmean=ABPMean(T0-600:T0+60);
h1_2928abpdias=ABPDias(T0-600:T0+60);
h1_2928hr=HR(T0-600:T0+60);
h1_2928pulse=PULSE(T0-600:T0+60);


load h2_a40006
T0_006=1755;
FW_006=T0_006+60;
h2_006abpmean=ABPMean(T0_006-600:FW_006);
h2_006abpdias=ABPDias(T0_006-600:FW_006);
h2_006hr=HR(T0_006-600:FW_006);
h2_006pulse=PULSE(T0_006-600:FW_006);

load h2_a40012
T0_012=4842;
FW_012=T0_012+60;
h2_012abpmean=ABPMean(T0_012-600:FW_012);
h2_012abpdias=ABPDias(T0_012-600:FW_012);
h2_012hr=HR(T0_012-600:FW_012);
h2_012pulse=PULSE(T0_012-600:FW_012);

load h2_a40050
T0_050=2857;
FW_050=T0_050+60;
h2_050abpmean=ABPMean(T0_050-600:FW_050);
h2_050abpdias=ABPDias(T0_050-600:FW_050);
h2_050hr=HR(T0_050-600:FW_050);
h2_050pulse=PULSE(T0_050-600:FW_050);

load h2_a40051
T0_051=4011;
FW_051=T0_051+60;
h2_051abpmean=ABPMean(T0_051-600:FW_051);
h2_051abpdias=ABPDias(T0_051-600:FW_051);
h2_051hr=HR(T0_051-600:FW_051);
h2_051pulse=PULSE(T0_051-600:FW_051);

load h2_a40064
T0_064=3706;
FW_064=T0_064+60;
h2_064abpmean=ABPMean(T0_064-600:FW_064);
h2_064abpdias=ABPDias(T0_064-600:FW_064);
h2_064hr=HR(T0_064-600:FW_064);
h2_064pulse=PULSE(T0_064-600:FW_064);

load h2_a40076
T0=3736;
h2_076abpmean=ABPMean(T0-600:T0+60);
h2_076abpdias=ABPDias(T0-600:T0+60);
h2_076hr=HR(T0-600:T0+60);
h2_076pulse=PULSE(T0-600:T0+60);

load h2_a40096
T0=1334;
h2_096abpmean=ABPMean(T0-600:T0+60);
h2_096abpdias=ABPDias(T0-600:T0+60);
h2_096hr=HR(T0-600:T0+60);
h2_096pulse=PULSE(T0-600:T0+60);

load h2_a40099
T0=3121;
h2_099abpmean=ABPMean(T0-600:T0+60);
h2_099abpdias=ABPDias(T0-600:T0+60);
h2_099hr=HR(T0-600:T0+60);
h2_099pulse=PULSE(T0-600:T0+60);

load h2_a40113
T0=14031;
h2_113abpmean=ABPMean(T0-600:T0+60);
h2_113abpdias=ABPDias(T0-600:T0+60);
h2_113hr=HR(T0-600:T0+60);
h2_113pulse=PULSE(T0-600:T0+60);

load h2_a40119
T0=6294;
h2_119abpmean=ABPMean(T0-600:T0+60);
h2_119abpdias=ABPDias(T0-600:T0+60);
h2_119hr=HR(T0-600:T0+60);
h2_119pulse=PULSE(T0-600:T0+60);

load h2_a40125
T0=6990;
h2_125abpmean=ABPMean(T0-600:T0+60);
h2_125abpdias=ABPDias(T0-600:T0+60);
h2_125hr=HR(T0-600:T0+60);
h2_125pulse=PULSE(T0-600:T0+60);

load h2_a40127
T0=7841;
h2_127abpmean=ABPMean(T0-600:T0+60);
h2_127abpdias=ABPDias(T0-600:T0+60);
h2_127hr=HR(T0-600:T0+60);
h2_127pulse=PULSE(T0-600:T0+60);

load h2_a40154
T0=5169;
h2_154abpmean=ABPMean(T0-600:T0+60);
h2_154abpdias=ABPDias(T0-600:T0+60);
h2_154hr=HR(T0-600:T0+60);
h2_154pulse=PULSE(T0-600:T0+60);

load h2_a40164
T0=6487;
h2_164abpmean=ABPMean(T0-600:T0+60);
h2_164abpdias=ABPDias(T0-600:T0+60);
h2_164hr=HR(T0-600:T0+60);
h2_164pulse=PULSE(T0-600:T0+60);

load h2_a40172
T0=4860;
h2_172abpmean=ABPMean(T0-600:T0+60);
h2_172abpdias=ABPDias(T0-600:T0+60);
h2_172hr=HR(T0-600:T0+60);
h2_172pulse=PULSE(T0-600:T0+60);


load c1_a40282
T0_282=1367;
FW_282=T0_282+60;
c1_282abpmean=ABPMean(T0_282-600:FW_282);
c1_282abpdias=ABPDias(T0_282-600:FW_282);
c1_282hr=HR(T0_282-600:FW_282);
c1_282pulse=PULSE(T0_282-600:FW_282);

load c1_a40473
T0_473=2944;
FW_473=T0_473+60;
c1_473abpmean=ABPMean(T0_473-600:FW_473);
c1_473abpdias=ABPDias(T0_473-600:FW_473);
c1_473hr=HR(T0_473-600:FW_473);
c1_473pulse=PULSE(T0_473-600:FW_473);

load c1_a40551
T0_551=5897;
FW_551=T0_551+60;
c1_551abpmean=ABPMean(T0_551-600:FW_551);
c1_551abpdias=ABPDias(T0_551-600:FW_551);
c1_551hr=HR(T0_551-600:FW_551);
c1_551pulse=PULSE(T0_551-600:FW_551);

load c1_a40802
T0_802=2252;
FW_802=T0_802+60;
c1_802abpmean=ABPMean(T0_802-600:FW_802);
c1_802abpdias=ABPDias(T0_802-600:FW_802);
c1_802hr=HR(T0_802-600:FW_802);
c1_802pulse=PULSE(T0_802-600:FW_802);

load c1_a40921
T0_921=1085;
FW_921=T0_921+60;
c1_921abpmean=ABPMean(T0_921-600:FW_921);
c1_921abpdias=ABPDias(T0_921-600:FW_921);
c1_921hr=HR(T0_921-600:FW_921);
c1_921pulse=PULSE(T0_921-600:FW_921);

load c1_a41137
T0=617;
c1_1137abpmean=ABPMean(T0-600:T0+60);
c1_1137abpdias=ABPDias(T0-600:T0+60);
c1_1137hr=HR(T0-600:T0+60);
c1_1137pulse=PULSE(T0-600:T0+60);

load c1_a41177
T0=3332;
c1_1177abpmean=ABPMean(T0-600:T0+60);
c1_1177abpdias=ABPDias(T0-600:T0+60);
c1_1177hr=HR(T0-600:T0+60);
c1_1177pulse=PULSE(T0-600:T0+60);

load c1_a41385
T0=1808;
c1_1385abpmean=ABPMean(T0-600:T0+60);
c1_1385abpdias=ABPDias(T0-600:T0+60);
c1_1385hr=HR(T0-600:T0+60);
c1_1385pulse=PULSE(T0-600:T0+60);


load c1_a41434
T0=5186;
c1_1434abpmean=ABPMean(T0-600:T0+60);
c1_1434abpdias=ABPDias(T0-600:T0+60);
c1_1434hr=HR(T0-600:T0+60);
c1_1434pulse=PULSE(T0-600:T0+60);

load c1_a41466
T0=1005;
c1_1466abpmean=ABPMean(T0-600:T0+60);
c1_1466abpdias=ABPDias(T0-600:T0+60);
c1_1466hr=HR(T0-600:T0+60);
c1_1466pulse=PULSE(T0-600:T0+60);

load c1_a41495
T0=1414;
c1_1495abpmean=ABPMean(T0-600:T0+60);
c1_1495abpdias=ABPDias(T0-600:T0+60);
c1_1495hr=HR(T0-600:T0+60);
c1_1495pulse=PULSE(T0-600:T0+60);

load c1_a41664
T0=1510;
c1_1664abpmean=ABPMean(T0-600:T0+60);
c1_1664abpdias=ABPDias(T0-600:T0+60);
c1_1664hr=HR(T0-600:T0+60);
c1_1664pulse=PULSE(T0-600:T0+60);

load c1_a41934
T0=2028;
c1_1934abpmean=ABPMean(T0-600:T0+60);
c1_1934abpdias=ABPDias(T0-600:T0+60);
c1_1934hr=HR(T0-600:T0+60);
c1_1934pulse=PULSE(T0-600:T0+60);

load c1_a42414
T0=1215;
c1_2414abpmean=ABPMean(T0-600:T0+60);
c1_2414abpdias=ABPDias(T0-600:T0+60);
c1_2414hr=HR(T0-600:T0+60);
c1_2414pulse=PULSE(T0-600:T0+60);

load c1_a42259
T0=713;
c1_2259abpmean=ABPMean(T0-600:T0+60);
c1_2259abpdias=ABPDias(T0-600:T0+60);
c1_2259hr=HR(T0-600:T0+60);
c1_2259pulse=PULSE(T0-600:T0+60);


load c2_a40207
T0_207=5800;
FW_207=T0_207+60;
c2_207abpmean=ABPMean(T0_207-600:FW_207);
c2_207abpdias=ABPDias(T0_207-600:FW_207);
c2_207hr=HR(T0_207-600:FW_207);
c2_207pulse=PULSE(T0_207-600:FW_207);

load c2_a40215
T0_215=670;
FW_215=T0_215+60;
c2_215abpmean=ABPMean(T0_215-600:FW_215);
c2_215abpdias=ABPDias(T0_215-600:FW_215);
c2_215hr=HR(T0_215-600:FW_215);
c2_215pulse=PULSE(T0_215-600:FW_215);

load c2_a40225
T0_225=5492;
FW_225=T0_225+60;
c2_225abpmean=ABPMean(T0_225-600:FW_225);
c2_225abpdias=ABPDias(T0_225-600:FW_225);
c2_225hr=HR(T0_225-600:FW_225);
c2_225pulse=PULSE(T0_225-600:FW_225);

load c2_a40234
T0_234=17377;
FW_234=T0_234+60;
c2_234abpmean=ABPMean(T0_234-600:FW_234);
c2_234abpdias=ABPDias(T0_234-600:FW_234);
c2_234hr=HR(T0_234-600:FW_234);
c2_234pulse=PULSE(T0_234-600:FW_234);

load c2_a40260
T0_260=1339;
FW_260=T0_260+60;
c2_260abpmean=ABPMean(T0_260-600:FW_260);
c2_260abpdias=ABPDias(T0_260-600:FW_260);
c2_260hr=HR(T0_260-600:FW_260);
c2_260pulse=PULSE(T0_260-600:FW_260);

load c2_a40264
T0=10110;
c2_264abpmean=ABPMean(T0-600:T0+60);
c2_264abpdias=ABPDias(T0-600:T0+60);
c2_264hr=HR(T0-600:T0+60);
c2_264pulse=PULSE(T0-600:T0+60);

load c2_a40277
T0=4975;
c2_277abpmean=ABPMean(T0-600:T0+60);
c2_277abpdias=ABPDias(T0-600:T0+60);
c2_277hr=HR(T0-600:T0+60);
c2_277pulse=PULSE(T0-600:T0+60);


load c2_a40306
T0=2243;
c2_306abpmean=ABPMean(T0-600:T0+60);
c2_306abpdias=ABPDias(T0-600:T0+60);
c2_306hr=HR(T0-600:T0+60);
c2_306pulse=PULSE(T0-600:T0+60);

load c2_a40329
T0=10303;
c2_329abpmean=ABPMean(T0-600:T0+60);
c2_329abpdias=ABPDias(T0-600:T0+60);
c2_329hr=HR(T0-600:T0+60);
c2_329pulse=PULSE(T0-600:T0+60);

load c2_a40355
T0=10225;
c2_355abpmean=ABPMean(T0-600:T0+60);
c2_355abpdias=ABPDias(T0-600:T0+60);
c2_355hr=HR(T0-600:T0+60);
c2_355pulse=PULSE(T0-600:T0+60);

load c2_a40374
T0=3096;
c2_374abpmean=ABPMean(T0-600:T0+60);
c2_374abpdias=ABPDias(T0-600:T0+60);
c2_374hr=HR(T0-600:T0+60);
c2_374pulse=PULSE(T0-600:T0+60);

load c2_a40376
T0=6645;
c2_376abpmean=ABPMean(T0-600:T0+60);
c2_376abpdias=ABPDias(T0-600:T0+60);
c2_376hr=HR(T0-600:T0+60);
c2_376pulse=PULSE(T0-600:T0+60);

load c2_a40384
T0=4206;
c2_384abpmean=ABPMean(T0-600:T0+60);
c2_384abpdias=ABPDias(T0-600:T0+60);
c2_384hr=HR(T0-600:T0+60);
c2_384pulse=PULSE(T0-600:T0+60);

load c2_a40408
T0=3099;
c2_408abpmean=ABPMean(T0-600:T0+60);
c2_408abpdias=ABPDias(T0-600:T0+60);
c2_408hr=HR(T0-600:T0+60);
c2_408pulse=PULSE(T0-600:T0+60);

load c2_a40424
T0=4512;
c2_424abpmean=ABPMean(T0-600:T0+60);
c2_424abpdias=ABPDias(T0-600:T0+60);
c2_424hr=HR(T0-600:T0+60);
c2_424pulse=PULSE(T0-600:T0+60);

testdata_ABPMean=[h1_439abpmean,h1_493abpmean,h1_764abpmean,h1_834abpmean,...
    h1_928abpmean,h1_1200abpmean,h1_1447abpmean,h1_1770abpmean,h1_1835abpmean,...
    h1_1882abpmean,h1_1925abpmean,h1_2277abpmean,h1_2397abpmean,h1_2410abpmean,...
    h1_2928abpmean,h2_006abpmean,h2_012abpmean,h2_050abpmean,h2_051abpmean,...
    h2_064abpmean,h2_076abpmean,h2_096abpmean,h2_099abpmean,h2_113abpmean,...
    h2_119abpmean,h2_125abpmean,h2_127abpmean,h2_154abpmean, h2_164abpmean,...
    h2_172abpmean,c1_282abpmean,c1_473abpmean,c1_551abpmean,c1_802abpmean,...
    c1_921abpmean,c1_1137abpmean,c1_1177abpmean,c1_1385abpmean,c1_1434abpmean,...
    c1_1466abpmean,c1_1495abpmean,c1_1664abpmean,c1_1934abpmean,c1_2414abpmean,...
    c1_2259abpmean,c2_207abpmean,c2_215abpmean,c2_225abpmean,c2_234abpmean,...
    c2_260abpmean,c2_264abpmean,c2_277abpmean,c2_306abpmean,c2_329abpmean,...
    c2_355abpmean,c2_374abpmean,c2_376abpmean,c2_384abpmean,c2_408abpmean,...
    c2_424abpmean];
    
testdata_ABPDias=[h1_439abpdias,h1_493abpdias,h1_764abpdias,h1_834abpdias,...
    h1_928abpdias,h1_1200abpdias,h1_1447abpdias,h1_1770abpdias,h1_1835abpdias,...
    h1_1882abpdias,h1_1925abpdias,h1_2277abpdias,h1_2397abpdias,h1_2410abpdias,...
    h1_2928abpdias,h2_006abpdias,h2_012abpdias,h2_050abpdias,h2_051abpdias,...
    h2_064abpdias,h2_076abpdias,h2_096abpdias,h2_099abpdias,h2_113abpdias,...
    h2_119abpdias,h2_125abpdias,h2_127abpdias,h2_154abpdias, h2_164abpdias,...
    h2_172abpdias,c1_282abpdias,c1_473abpdias,c1_551abpdias,c1_802abpdias,...
    c1_921abpdias,c1_1137abpdias,c1_1177abpdias,c1_1385abpdias,c1_1434abpdias,...
    c1_1466abpdias,c1_1495abpdias,c1_1664abpdias,c1_1934abpdias,c1_2414abpdias,...
    c1_2259abpdias,c2_207abpdias,c2_215abpdias,c2_225abpdias,c2_234abpdias,...
    c2_260abpdias,c2_264abpdias,c2_277abpdias,c2_306abpdias,c2_329abpdias,...
    c2_355abpdias,c2_374abpdias,c2_376abpdias,c2_384abpdias,c2_408abpdias,...
    c2_424abpdias];
 testdata_HR=[h1_439hr,h1_493hr,h1_764hr,h1_834hr,h1_928hr,h1_1200hr,...
     h1_1447hr,h1_1770hr,h1_1835hr,h1_1882hr,h1_1925hr,h1_2277hr,h1_2397hr,...
     h1_2410hr,h1_2928hr,h2_006hr,h2_012hr,h2_050hr,h2_051hr,h2_064hr,...
     h2_076hr,h2_096hr,h2_099hr,h2_113hr,h2_119hr,h2_125hr,h2_127hr,h2_154hr,...
     h2_164hr,h2_172hr,c1_282hr,c1_473hr,c1_551hr,c1_802hr,c1_921hr,....
     c1_1137hr,c1_1177hr,c1_1385hr,c1_1434hr,c1_1466hr,c1_1495hr,c1_1664hr,...
     c1_1934hr,c1_2414hr,c1_2259hr,c2_207hr,c2_215hr,c2_225hr,c2_234hr,c2_260hr,...
     c2_264hr,c2_277hr,c2_306hr,c2_329hr,c2_355hr,c2_374hr,c2_376hr,c2_384hr,...
     c2_408hr,c2_424hr];
 testdata_PULSE=[h1_439pulse,h1_493pulse,h1_764pulse,h1_834pulse,h1_928pulse,...
     h1_1200pulse,h1_1447pulse,h1_1770pulse,h1_1835pulse,h1_1882pulse,...
     h1_1925pulse,h1_2277pulse,h1_2397pulse,h1_2410pulse,h1_2928pulse,...
     h2_006pulse,h2_012pulse,h2_050pulse,h2_051pulse,h2_064pulse,h2_076pulse,...
     h2_096pulse,h2_099pulse,h2_113pulse,h2_119pulse,h2_125pulse,h2_127pulse,...
     h2_154pulse,h2_164pulse,h2_172pulse,c1_282pulse,c1_473pulse,c1_551pulse,...
     c1_802pulse,c1_921pulse,c1_1137pulse,c1_1177pulse,c1_1385pulse,...
     c1_1434pulse,c1_1466pulse,c1_1495pulse,c1_1664pulse,c1_1934pulse,...
     c1_2414pulse,c1_2259pulse,c2_207pulse,c2_215pulse,c2_225pulse,...
     c2_234pulse,c2_260pulse,c2_264pulse,c2_277pulse,c2_306pulse,...
     c2_329pulse,c2_355pulse,c2_374pulse,c2_376pulse,c2_384pulse,...
     c2_408pulse,c2_424pulse,];