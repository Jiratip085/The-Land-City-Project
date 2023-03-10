#include <YSI\y_hooks>

//Crate

forward PutdownProduct(playerid);
public PutdownProduct(playerid)
{
	new
	    idcrate;

	BitFlag_Off(g_PlayerFlags[playerid], PLAYER_PICKUPING);

    if(Character[playerid][CarryPD] == 1)
    {
	    idcrate = Crate_Create(playerid, 1);

		Crate_Refresh(idcrate);

		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);

		Character[playerid][LoadingPD] = 0;
		Character[playerid][CarryPD] = 0;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		RemoveAttachedObject(playerid, 4);
	}
	if(Character[playerid][CarryPD] == 2)
    {
	    idcrate = Crate_Create(playerid, 2);

		Crate_Refresh(idcrate);

		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);

		Character[playerid][LoadingPD] = 0;
		Character[playerid][CarryPD] = 0;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		RemoveAttachedObject(playerid, 4);
	}
	return 1;
}

forward PickupProduct(playerid, productid);
public PickupProduct(playerid, productid)
{
	SetPlayerAttachedObject(playerid,4,2912,4,0.345999,-0.554000,0.116999,0.000000,-95.599983,0.000000,0.850999,0.861000,1.000000);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	BitFlag_On(g_PlayerFlags[playerid], PLAYER_PICKUPING);
	return 1;
}

forward BuyProduct(playerid, productid);
public BuyProduct(playerid, productid)
{
	new
	    string[128];

    BitFlag_On(g_PlayerFlags[playerid], PLAYER_PICKUPING);

	if (Product_Nearest(playerid) != productid || !ProductData[productid][productExists])
	    return 0;

	switch (ProductData[productid][productType])
	{
	    case 1:
	    {
	        ProductData[productid][productAmount] -= 1;

         	SetPlayerAttachedObject(playerid,4,2912,4,0.345999,-0.554000,0.116999,0.000000,-95.599983,0.000000,0.850999,0.861000,1.000000);

      		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

			ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);

   			Character[playerid][CarryPD] = 1;
   			Character[playerid][LoadingPD] = 1;

			Character[playerid][Cash] -= ProductData[productid][productPrice];
			GivePlayerMoney(playerid, -ProductData[productid][productPrice]);

	        format(string, sizeof(string), "?????????????????????????????????? $%d", ProductData[productid][productPrice]);
	        SendClientMessage(playerid, COLOR_WHITE, string);
		}
		case 2:
	    {
	        ProductData[productid][productAmount] -= 1;

         	SetPlayerAttachedObject(playerid,4,2912,4,0.345999,-0.554000,0.116999,0.000000,-95.599983,0.000000,0.850999,0.861000,1.000000);

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

			ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);

			Character[playerid][CarryPD] = 2;
			Character[playerid][LoadingPD] = 1;

			Character[playerid][Cash] -= ProductData[productid][productPrice];
			GivePlayerMoney(playerid, -ProductData[productid][productPrice]);

	        format(string, sizeof(string), "???????????????????????????????????????? $%d", ProductData[productid][productPrice]);
	        SendClientMessage(playerid, COLOR_WHITE, string);
		}
	}
	Product_Refresh(productid);
	Product_Save(productid);
	return 1;
}

forward SellProduct(playerid, productid);
public SellProduct(playerid, productid)
{
	new
	    string[128];

    BitFlag_Off(g_PlayerFlags[playerid], PLAYER_PICKUPING);

    if (Product_Nearest(playerid) != productid || !ProductData[productid][productExists])
	    return 0;

	switch (ProductData[productid][productType])
	{
	    case 1:
	    {
     		if(Character[playerid][CarryPD] != 1)
       			return SendClientMessage(playerid, -1, "?????????????????????????????????????????????????!");

			if(ProductData[productid][productAmount] == Product_MaxGrams(ProductData[productid][productType]))
  				return SendClientMessage(playerid, -1, "????????????????????!");

			ProductData[productid][productAmount] += 1;

			ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);

			Character[playerid][LoadingPD] = 0;
			Character[playerid][CarryPD] = 0;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			RemoveAttachedObject(playerid, 4);

			Character[playerid][Cash] += ProductData[productid][productPrice];
			GivePlayerMoney(playerid, ProductData[productid][productPrice]);

			format(string, sizeof(string), "????????????????????????????????? $%d", ProductData[productid][productPrice]);
   			SendClientMessage(playerid, COLOR_WHITE, string);
		}
		case 2:
	    {
     		if(Character[playerid][CarryPD] != 2)
       			return SendClientMessage(playerid, -1, "?????????????????????????????????????????????????!");

			if(ProductData[productid][productAmount] == Product_MaxGrams(ProductData[productid][productType]))
  				return SendClientMessage(playerid, -1, "????????????????????!");

			ProductData[productid][productAmount] += 1;

			ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);

			Character[playerid][LoadingPD] = 0;
			Character[playerid][CarryPD] = 0;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			RemoveAttachedObject(playerid, 4);

			Character[playerid][Cash] += ProductData[productid][productPrice];
			GivePlayerMoney(playerid, ProductData[productid][productPrice]);

			format(string, sizeof(string), "??????????????????????????????????????? $%d", ProductData[productid][productPrice]);
   			SendClientMessage(playerid, COLOR_WHITE, string);
		}
	}
	Product_Refresh(productid);
	Product_Save(productid);
 	return 1;
}

Dialog:Cargotrunk(playerid, response, listitem, inputtext[], carid)
{
    if (Character[playerid][LoadingPD] == 1)
 			return SendClientMessage(playerid, COLOR_WHITE, "????????????????????????????????!");

	if (response)
	{
		switch (listitem)
		{
		    case 0:
		    {
		        for (new i = 1; i != MAX_VEHICLES; i ++) if (IsPlayerNearBoot(playerid, i))
				{
					if(CoreVehicles[i][vehPDLoads1] < 1)
					    return SendClientMessage(playerid, COLOR_WHITE, "???????????????????? '??????????'!");

			        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
			        SetPlayerAttachedObject(playerid,4,2912,4,0.345999,-0.554000,0.116999,0.000000,-95.599983,0.000000,0.850999,0.861000,1.000000);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	                Character[playerid][CarryPD] = 1;
					Character[playerid][LoadingPD] = 1;

					CoreVehicles[i][vehPDLoads1]--;
					CoreVehicles[i][vehLoads]--;
					return 1;
				}
		    }
		    case 1:
		    {
		        for (new i = 1; i != MAX_VEHICLES; i ++) if (IsPlayerNearBoot(playerid, i))
				{
                    if(CoreVehicles[i][vehPDLoads2] < 1)
					    return SendClientMessage(playerid, COLOR_WHITE, "???????????????????? '???????????'!");

			        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
			        SetPlayerAttachedObject(playerid,4,2912,4,0.345999,-0.554000,0.116999,0.000000,-95.599983,0.000000,0.850999,0.861000,1.000000);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	                Character[playerid][CarryPD] = 2;
					Character[playerid][LoadingPD] = 1;

					CoreVehicles[i][vehPDLoads2]--;
					CoreVehicles[i][vehLoads]--;
					return 1;
				}
		    }
		}
	}
	return 1;
}

VehProduct(playerid, carid)
{
   	Dialog_Show(playerid, Cargotrunk, DIALOG_STYLE_LIST, "Cargo Trunk", "[??????????? '??????????' : %d]\n[??????????? '???????????' : %d]", "?????", "??????", CoreVehicles[carid][vehPDLoads1], CoreVehicles[carid][vehPDLoads2]);
}

//Products

CMD:cargo(playerid, params[], productid)
{
    new
	    type[24],
	    idcrate,
	    id = Product_Nearest(playerid),
		string[128];

	if(Character[playerid][Job] != 1)
	    return SendClientMessage(playerid, COLOR_GREY, "????????? Trucker!");

	if (sscanf(params, "s[24]S()[128]", type, string))
 	{
	    SendClientMessage(playerid, COLOR_GREY, "Available commands:");
	    SendClientMessage(playerid, COLOR_YELLOW, "/cargo list {FFFFFF}- ?????????????????????????????????????????????????????????");
	    SendClientMessage(playerid, COLOR_YELLOW, "/cargo place {FFFFFF}- ????????????????????????????????????????");
	    SendClientMessage(playerid, COLOR_YELLOW, "/cargo putdown {FFFFFF}- ?????????????????????????");
	    SendClientMessage(playerid, COLOR_YELLOW, "/cargo pickup {FFFFFF}- ??????????????????????????");
	    SendClientMessage(playerid, COLOR_YELLOW, "/cargo buy {FFFFFF}- ??????????????????????????????????????????");
	    SendClientMessage(playerid, COLOR_YELLOW, "/cargo sell {FFFFFF}- ??????????????????????????(??? '/cargo buy')");
	    SendClientMessage(playerid, COLOR_YELLOW, "/cargo deliver {FFFFFF}- ????????????????????????? / ???????");
		return 1;
	}

	if (!strcmp(type, "buy", true))
	{
	    if (id == -1)
	    	return SendClientMessage(playerid, COLOR_GREY, "??????????????????????????????????");

        if (Character[playerid][LoadingPD] == 1)
 			return SendClientMessage(playerid, COLOR_WHITE, "????????????????????????????????!");

	    if(ProductData[id][productAmount] <= 0)
	        return SendClientMessage(playerid, -1, "????????????????????????????????????");

		if(Character[playerid][Cash] < ProductData[id][productPrice])
			return SendClientMessage(playerid, -1, "????????????????????????????????!");

		SetTimerEx("BuyProduct", 100, false, "dd", playerid, id);
		return 1;

	}
	if (!strcmp(type, "sell", true))
	{
	    if (id == -1)
	    	return SendClientMessage(playerid, COLOR_GREY, "??????????????????????????????????");

        if (Character[playerid][LoadingPD] == 0)
 			return SendClientMessage(playerid, COLOR_WHITE, "??????????????????????????!");

		SetTimerEx("SellProduct", 100, false, "dd", playerid, id);
		return 1;

	}
	if (!strcmp(type, "deliver", true))
	{
        new
	    	idpoint = ProductPoint_Nearest(playerid);

	    if (idpoint == -1)
	    	return SendClientMessage(playerid, COLOR_GREY, "????????????????????????");

	    if (Character[playerid][LoadingPD] == 0)
			return SendClientMessage(playerid, COLOR_WHITE, "??????????????????????????!");

     	if(Character[playerid][CarryPD] == 1) //??????????
	    {
			if(Character[playerid][CarryPD] != 1)
				return SendClientMessage(playerid, -1, "?????????????????????????????????????????????????!");

			if(ProductData[idpoint][productAmount] == Product_MaxGrams(ProductData[idpoint][productType]))
				return SendClientMessage(playerid, -1, "????????????????????!");

			ProductData[idpoint][productPointAmount] += 1;

			ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);

			Character[playerid][LoadingPD] = 0;
			Character[playerid][CarryPD] = 0;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			RemoveAttachedObject(playerid, 4);

			Character[playerid][Cash] += ProductData[idpoint][productPointPrice];
			GivePlayerMoney(playerid, ProductData[idpoint][productPointPrice]);

			format(string, sizeof(string), "????????????????????????????????? $%d", ProductData[idpoint][productPointPrice]);
			SendClientMessage(playerid, COLOR_WHITE, string);

			Product_Refresh(idpoint);
			Product_Save(idpoint);
		}

	    if(Character[playerid][CarryPD] == 2) //???????????
	    {
			if(Character[playerid][CarryPD] != 2)
				return SendClientMessage(playerid, -1, "?????????????????????????????????????????????????!");

			if(ProductData[idpoint][productAmount] == Product_MaxGrams(ProductData[idpoint][productType]))
				return SendClientMessage(playerid, -1, "????????????????????!");

			ProductData[idpoint][productPointAmount] += 1;

			ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);

			Character[playerid][LoadingPD] = 0;
			Character[playerid][CarryPD] = 0;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			RemoveAttachedObject(playerid, 4);

			Character[playerid][Cash] += ProductData[idpoint][productPointPrice];
			GivePlayerMoney(playerid, ProductData[idpoint][productPointPrice]);

			format(string, sizeof(string), "??????????????????????????????????????? $%d", ProductData[idpoint][productPointPrice]);
			SendClientMessage(playerid, COLOR_WHITE, string);

			Product_Refresh(idpoint);
			Product_Save(idpoint);
	    }
		return 1;
	}
	else if (!strcmp(type, "putdown", true))
	{
 		if (Character[playerid][LoadingPD] < 1)
 			return SendClientMessage(playerid, COLOR_WHITE, "??????????????????????????!");

        if (idcrate == -1)
	    	return SendClientMessage(playerid, COLOR_WHITE, "???????????????????????????????????????");

        if(Character[playerid][CarryPD] == 1)
        {
            SetTimerEx("PutdownProduct", 100, false, "d", playerid);
			return 1;
		}
		if(Character[playerid][CarryPD] == 2)
        {
            SetTimerEx("PutdownProduct", 100, false, "d", playerid);
			return 1;
		}
	}
	else if (!strcmp(type, "pickup", true))
	{
	    if (Character[playerid][LoadingPD] == 1)
 			return SendClientMessage(playerid, COLOR_WHITE, "????????????????????????????????!");

	    if((idcrate = Crate_Nearest(playerid)) != -1)
	    {
	        Character[playerid][CarryPD] = CrateData[idcrate][crateType];
			Character[playerid][LoadingPD] = 1;

			SetTimerEx("PickupProduct", 100, false, "dd", playerid, id);

			ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);

			Crate_Delete(idcrate);
			return 1;
		}
	}
	else if (!strcmp(type, "list", true))
	{
	    if (Character[playerid][LoadingPD] == 1)
 			return SendClientMessage(playerid, COLOR_WHITE, "????????????????????????????????!");

	    for (new i = 1; i != MAX_VEHICLES; i ++) if (IsPlayerNearBoot(playerid, i))
		{
		    VehProduct(playerid, i);
		}
	}
	else if (!strcmp(type, "place", true))
	{
        for (new i = 1; i != MAX_VEHICLES; i ++) if (IsPlayerNearBoot(playerid, i))
		{
		    if (!IsLoadableVehicle(i))
      			return SendClientMessage(playerid, COLOR_WHITE, "???????????????????????????????????????????");

            if (CoreVehicles[i][vehLoadType] != 0 && CoreVehicles[i][vehLoadType] != Character[playerid][LoadType])
				return SendClientMessage(playerid, COLOR_WHITE, "?????????????????????????????????????????????");

			if (CoreVehicles[i][vehLoads] >= 6)
   				return SendClientMessage(playerid, COLOR_WHITE, "????????????????????????????????? 6 ???");

            if (Character[playerid][LoadingPD] < 1)
	    		return SendClientMessage(playerid, COLOR_WHITE, "??????????????????????????!");

			if(Character[playerid][CarryPD] == 1)
			{
	   			CoreVehicles[i][vehLoads]++;
	   			CoreVehicles[i][vehPDLoads1]++;
	   			CoreVehicles[i][vehLoadType] = Character[playerid][LoadType];

				ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
	   			//SendNearbyMessage(playerid, 30.0, COLOR_RP, "** %s ????????????????? %s", ReturnName(playerid, 0), ReturnVehicleName(i));

	            Character[playerid][LoadingPD] = 0;
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	 			RemoveAttachedObject(playerid, 4);
			}
			if(Character[playerid][CarryPD] == 2)
			{
	   			CoreVehicles[i][vehLoads]++;
	   			CoreVehicles[i][vehPDLoads2]++;
	   			CoreVehicles[i][vehLoadType] = Character[playerid][LoadType];

				ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
	   			//SendNearbyMessage(playerid, 30.0, COLOR_RP, "** %s ????????????????? %s", ReturnName(playerid, 0), ReturnVehicleName(i));

	            Character[playerid][LoadingPD] = 0;
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	 			RemoveAttachedObject(playerid, 4);
			}
		}
	}
	return 1;
}
