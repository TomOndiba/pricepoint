using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_ViewProfile : System.Web.UI.Page
{
    DB_Helper db = new DB_Helper();

    public int currentUser
    {
        get
        {
            int curUser;
            if (int.TryParse(Request.QueryString["id"], out curUser))
            {
                return curUser;
            }

            return -1;
        }
    }
    private DataRow _currentUserData;

    private DataRow currentUserData
    {
        get
        {
            if (_currentUserData == null)
            {
                _currentUserData = db.GetRow(string.Format("select * from users where id_user = {0}", currentUser));
            }

            return _currentUserData;
        }
    }

    private DataTable userPhotos;
    protected DataRow userRow;
    private bool isAnyHistory = false;
    private List<Tuple<DateTime, string>> history = new List<Tuple<DateTime, string>>();

    public static List<Tuple<string, string>> LookingFor = new List<Tuple<string, string>>()
    {
        new Tuple<string, string>( "lookingforshortterm", "Short Term Dating"),
        new Tuple<string, string>("lookingforfriendship","Friendship - Activity Partner" ),
        new Tuple<string, string>("lookingforlongterm","Long Term Relationship - Posibly Marridge"),
        new Tuple<string, string>("lookingforarrangement","Mutually Beneficial Arangement"),
        new Tuple<string, string>("lookingforaffair","Discreet Affair" ),
        new Tuple<string, string>("lookingforcasualdating", "Casual Dating - No Strings Atached")
    };

    string SheHe(string she, string he)
    {
        if (userRow["sex"].ToString() == "F") return she;
        return he;
    }
    public string SendOfferText;
    public string accepttext = "";
    void UpdateOffer()
    {
        int? mystate = null;
        int? thierstate = null;
        OfferText.InnerText = "";

        if (userRow["My_id_offer_state"] != DBNull.Value) mystate = Convert.ToInt32(userRow["My_id_offer_state"]);
        if (userRow["Their_id_offer_state"] != DBNull.Value) thierstate = Convert.ToInt32(userRow["Their_id_offer_state"]);

        //no offer yet
        this.BUT_SENDOFFER.Visible = mystate == null && thierstate == null;

        string offeredamount = "";
        if (userRow["IOfferedThem"] != DBNull.Value) offeredamount = Convert.ToDouble(userRow["IOfferedThem"]).ToString("C0");
        if (userRow["TheyOfferedMe"] != DBNull.Value) offeredamount = Convert.ToDouble(userRow["TheyOfferedMe"]).ToString("C0");

        //pending
        if ((mystate == 403 || mystate == 406) && thierstate == null) OfferText.InnerText = "You sent " + offeredamount + " offer"; 
        if (mystate == null && (thierstate == 403 || thierstate == 406))
        {
            //they are asking...
            DIV_ACCEPTCOUNTERREJECT.Visible = true;
            OfferText.InnerText = SheHe("She is asking ", "He is offering ") + " " + Convert.ToDouble(userRow["TheyOfferedMe"]).ToString("C0");
            OfferText.Visible = false;
            accepttext = Convert.ToDouble(userRow["TheyOfferedMe"]).ToString("C0") + " offer";
        }
        //rejected
        if (mystate == null && thierstate == 405) OfferText.InnerText = "You've rejected " + SheHe("her", "his") + " " + Convert.ToDouble(userRow["TheyOfferedMe"]).ToString("C0") + " offer";
        if (mystate == 405 && thierstate == null) OfferText.InnerText = SheHe("She", "He") + " rejected your " + Convert.ToDouble(userRow["IOfferedThem"]).ToString("C0") + " offer";
        bool rejected = (mystate == null && thierstate == 405) || (mystate == 405 && thierstate == null);
        if (rejected)
        {
            BUT_SENDOFFER.Visible = true;
            SendOfferText = "Send New Offer";
        }

        if (mystate == 404 || thierstate == 404)
        {
            BUT_SENDMESSAGE.Visible = true;
            agreedprice.Visible = true;
            agreedprice.InnerText = offeredamount;
        }

        bool IsUnlocked = userRow["Unlocked"].ToString() == "1";
        if (MyUtils.IsFemale || IsUnlocked) BUT_SENDMESSAGE.InnerHtml = BUT_SENDMESSAGE.InnerHtml.Replace("[SEND MESSAGE]", "Send Message");
        else
        {
            BUT_SENDMESSAGE.Attributes["class"] = "button button-green button-icon unlockbutton";
            BUT_SENDMESSAGE.InnerHtml = BUT_SENDMESSAGE.InnerHtml.Replace("[SEND MESSAGE]", "Unlock Messaging for " + Convert.ToInt32(userRow["UnlockCredits"]) + " credits");
        }

        if (OfferText.InnerText != "") OfferText.Style["display"] = "block";

        BUT_SENDMESSAGE.ServerClick += BUT_SENDMESSAGE_ServerClick;

        //Send offer is without gifts list
        if (MyUtils.IsFemale) BUT_SENDOFFER.Attributes.Add("data-counter", "1");
    }

    private void BUT_SENDMESSAGE_ServerClick(object sender, EventArgs e)
    {
        int id_offer = db.ExecuteScalarInt("select top 1 id_offer from offers where (id_user_to=" + id_user_profile + " and id_user_from=" + MyUtils.ID_USER + ") or (id_user_from=" + id_user_profile + " and id_user_to=" + MyUtils.ID_USER + ")");
        Utils.GoToSendMessage(id_offer);

    }
    public int id_user_profile
    {
        get
        {
            return Convert.ToInt32(userRow["id_user"]);
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {

        if (currentUser == -1)
        {
            DoesntExist();
            return;
        }

        userRow = GetUserData(out userPhotos);

        if (userRow == null)
        {
            DoesntExist();
            return;
        }

        int status = (int)userRow["status"];
        if (status < 0 && !MyUtils.IsUserAdminOrStaff())
        {
            DoesntExist();
            return;
        }
        if (status<0 && MyUtils.IsUserAdminOrStaff())
        {
            h2deleted.Visible = true;
            string s = "";
            if (status == -1) s = "REJECTED";
            if (status == -2) s = "BANNED";
            if (status == -10) s = "CANCELED";
            h2deleted.InnerHtml = "STATUS: " +s+" "+ status;
        }

        if (Convert.ToInt32(userRow["id_user"]) != MyUtils.ID_USER && userRow["sex"].ToString().ToUpper() == MyUtils.GetUserField("sex").ToString().ToUpper() && !MyUtils.IsUserAdminOrStaff() )
        {
            DoesntExist();
            return;
        }



        #region UserName
        ltUserName.Text = userRow["username"].ToString();
        #endregion

        #region Gender
        var userGender = userRow["sex"].ToString();

        lblGender.Text = userGender == "F" ? "(Female)" : "(Male)";
        #endregion

        #region Activity
        var lastLogin = userRow["lastlogin_time"];
        isonline.Visible = false;
        if (MyUtils.IsOnline((int)userRow["id_user"]))
        {
            ltActivity.Text = "Is Online";
            isonline.Visible = true;
        }
        else ltActivity.Text = "Last login: " + (lastLogin is DBNull ? "n /a" : MyUtils.TimeAgo(Convert.ToDateTime(lastLogin)));

        #endregion

        #region Age, Location, Distance
        var birthDate = Convert.ToDateTime(userRow["birthdate"]);
        var age = (DateTime.Now.Year - birthDate.Year);
        if (birthDate > DateTime.Now.AddYears(-age))
        {
            age--;
        }
        ltAge.Text = age.ToString();

        ltLocation.Text = userRow["place"].ToString();

        ltDistance.Text = userRow["distance"].ToString();
        #endregion

        #region Status
        ltStatus.Text = userRow["title"].ToString();
        #endregion

        #region About Me
        ltAbout.Text = fixtext(userRow["description"].ToString());
        #endregion

        #region First Date
        ltFirstDate.Text = fixtext(userRow["firstdate"].ToString());
        #endregion

        #region GetUserPersonalData
        userPersData.userData = GetUserPersonalData(userRow);

        //for mobile
        userPersDataForMobiles.userData = userPersData.userData;
        #endregion

        #region Extention Data
        userPersDataExtention.userData = GetUserExtentionData(userRow);
        #endregion

    }

    private string fixtext(string v)
    {
        v=HttpUtility.HtmlEncode(v);
        v=v.Replace("\n", "<br>");
        return v;
    }

    private void DoesntExist()
    {
        maincontainer.Visible = false;
        h2deleted.Visible = true;
        h2deleted.InnerHtml = "This profile either doesn't exist, deleted thier account, has been suspended, or you don't have a permission to view this profile.";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        SendOfferText = MyUtils.IsFemale ? "Name Your Price" : "Send Offer";

        this.btnBan.Visible = btEdit.Visible= MyUtils.IsUserAdmin();
        this.btEdit.OnClientClick = "window.location.href='" + "/Account/EditProfile?id=" + Convert.ToInt32(Request.QueryString["id"]) + "';return false;";

        //if (!IsPostBack)
        {
            Repeater1.DataSource = userPhotos;
            Repeater1.DataBind();

            List<string> g= GetUserGifts();
            if (g.Count > 0)
            {
                rpGifts.DataSource = g;
                rpGifts.DataBind();
            }
            else gifts.Visible = false;
        }

        ltPhotosCount.Text = GetPhotosCount().ToString();
        photoslabel.Visible = ltPhotosCount.Text != "0";

        if (currentUser < 0 || userRow==null) return;

        if (currentUser == (int)MyUtils.GetUserField("id_user"))
        {
            lActions.Visible = false;
            divReport.Visible = false;
            divMobileReport.Visible = false;
            liHistory.Visible = false;
        }
        else 
        {
            SetButtonBlock();

            if (MyUtils.IsUserAdmin())
            {

                btnBan.Text = btnBanMobile.Text = (int)userRow["status"] == -2 ? "Unban" : "Ban";
                btnBan.Visible = btnBanMobile.Visible = true;
            }
        }


        UpdateOffer();


    }

    private List<string> GetUserGifts()
    {
        List<string> girfts = new List<string>();

        if (userRow != null && !(userRow["gifts"] is DBNull))
        {
            girfts = userRow["gifts"].ToString().Split(',').ToList();
        }

        return girfts;
    }

    private void SetButtonBlock(bool? isBlocked = null)
    {
        if (currentUser != (int)MyUtils.GetUserField("id_user"))
        {
            if (isBlocked == null)
            {
                isBlocked = IsUserBlockedByYou();
            }

            btnBlock.Text = isBlocked.Value ? "Unblock" : "Block";
            if (isBlocked.Value) btnBlock.Style.Value = "background-color:red;color:white";
            else btnBlock.Style.Value = "";
            btnBlock.Attributes["onclick"] = string.Format("javascript: return confirm('Are you sure you want to {0}block {1}?');", isBlocked.Value ? "un" : "",userRow["username"]);

            btnMobileBlock.Text = btnBlock.Text;
            btnMobileBlock.Style.Value = btnBlock.Style.Value;
            btnMobileBlock.Attributes["onclick"] = btnBlock.Attributes["onclick"];
        }
    }


    private bool IsUserBlockedByYou()
    {
        DataRow userBlock = db.GetRow(string.Format("select * from Blocks where id_user_child = {0} and id_user = {1}", (int)MyUtils.GetUserField("id_user"), currentUser));
        return userBlock != null;
    }
    
    private bool IsUserBlockedYou()
    {
        DataRow userBlock = db.GetRow(string.Format("select * from Blocks where id_user = {0} and id_user_child = {1}", (int)MyUtils.GetUserField("id_user"), currentUser));
        return userBlock != null;
    }

    protected void btnBlock_Click(object sender, EventArgs e)
    {
        // Block
        if((sender as LinkButton).Text == "Block")
        {
            int newBlockId = 0;
            //Insert a new block to blocks table
            try
            {
                DataSet ds = db.CommandBuilder_LoadDataSet("select * from blocks where id =-1"); //get the columns schema
                DataRow newBlock = ds.Tables[0].NewRow();
                newBlock["id_user_child"] = (int)MyUtils.GetUserField("id_user");
                newBlock["id_user"] = currentUser;
                newBlock["time"] = DateTime.Now;
               
                ds.Tables[0].Rows.Add(newBlock);

                newBlockId = db.CommandBuilder_SaveDataset();

                SetButtonBlock(true);
                
            }
            finally
            {
                db.CommandBuilder_Disconnect();
            }
        }
        //Unblock
        else
        {
            try
            {
                db.Execute(string.Format("delete from blocks where id_user_child={0} and id_user = {1}", (int)MyUtils.GetUserField("id_user"), currentUser));
                SetButtonBlock(false);
            }
            finally
            {
                db.CommandBuilder_Disconnect();
            }
        }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {

    }

    private List<Tuple<string, string>> GetUserExtentionData(DataRow userD)
    {
        var userData = new List<Tuple<string, string>>();

        userData.Add(new Tuple<string, string>("Occupation", fixtext(userD["occupation"].ToString())));
        userData.Add(new Tuple<string, string>("Income Level", GetFromLookups(userD["id_income"].ToString())));
        userData.Add(new Tuple<string, string>("Net Worth", GetFromLookups(userD["id_networth"].ToString())));
        userData.Add(new Tuple<string, string>("Relationship Status", GetFromLookups(userD["id_relationship"].ToString())));
        //userData.Add(new Tuple<string, string>("Looking To Meet:", ""));
        userData.Add(new Tuple<string, string>("Interested In", GetInterestFromLookups(userD)));

        return userData;

    }

    private List<Tuple<string, string>> GetUserPersonalData(DataRow userD)
    {
        var userData = new List<Tuple<string, string>>();

        userData.Add(new Tuple<string, string>("Age", userD["age"].ToString() + " - " + GetZodiacSigh(Convert.ToDateTime(userD["birthdate"].ToString())) ));
        userData.Add(new Tuple<string, string>("Body Type", GetFromLookups(userD["id_height"].ToString()) + " - " + GetFromLookups(userD["id_bodytype"].ToString())));
        userData.Add(new Tuple<string, string>("Hair / Eyes", GetFromLookups(userD["id_haircolor"].ToString()) + " / " + GetFromLookups(userD["id_eyecolor"].ToString())));
        userData.Add(new Tuple<string, string>("Education", GetFromLookups(userD["id_education"].ToString())));
        userData.Add(new Tuple<string, string>("Children", GetFromLookups(userD["id_children"].ToString())));
        userData.Add(new Tuple<string, string>("Ethnicity", GetFromLookups(userD["id_ethnicity"].ToString())));
        userData.Add(new Tuple<string, string>("Religion", GetFromLookups(userD["id_religion"].ToString())));
        userData.Add(new Tuple<string, string>("Smoking / Drinking", GetFromLookups(userD["id_smoking"].ToString()) + " / " + GetFromLookups(userD["id_drinking"].ToString())));

        return userData;

    }

    private string GetFromLookups(string id)
    {
        DataRow userRow = null;

        if (!string.IsNullOrEmpty(id))
        {
            userRow = db.GetRow(string.Format("select * from lookups where id_lookup = {0}", id));
        }

        return (userRow != null) ? userRow["text"].ToString() : string.Empty;
    }

    private string GetInterestFromLookups(DataRow userData)
    {
        string result = string.Empty;

        foreach (var l in LookingFor)
        {
            if (!(userData[l.Item1] is DBNull) && Boolean.Parse(userData[l.Item1].ToString()) == true)
            {
                result += l.Item2 + " / ";
            }
        }

        if (!string.IsNullOrEmpty(result))
        {
            result = result.Remove(result.Length - 2);
        }

        return result;
    }

    public string sql="";

    /// <summary>
    /// Gets user personal data from DB using dbo.GET_USER_PROFILE
    /// </summary>
    /// <param name="userPhotos">user's personal photos</param>
    /// <returns>user's personal data</returns>
    private DataRow GetUserData(out DataTable userPhotos)
    {
        sql = string.Format("exec Get_User_Profile {0},{1},1", (int)MyUtils.GetUserField("id_user"), currentUser);
        DataSet ds = db.GetDataSet(sql);
        DataRow userRow = null;
        userPhotos = null;

        if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            userRow = ds.Tables[0].Rows[0];
            var photos = ds.Tables[1].Select("IsMainPhoto <> 1");
            userPhotos = photos.Length > 0 ? photos.CopyToDataTable() : null;
        }

        return userRow;
    }

    public string GetZodiacSigh(DateTime dateBirth)
    {
        string[] zodiac = new string[] { "Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces" };

        int days = dateBirth.Day;
        int month = dateBirth.Month;

        switch (month)
        {
            case 1:
                if (days >= 1 & days <= 19)
                {
                    return zodiac[9];
                }
                else
                {
                    return zodiac[10];
                }
            case 2:
                if (days >= 1 & days <= 18)
                {
                    return zodiac[10];
                }
                else
                {
                    return zodiac[11];
                }
            case 3:
                if (days >= 21)
                {
                    return zodiac[0];
                }
                else
                {
                    return zodiac[11];
                }
            case 4:
                if (days >= 1 & days <= 19)
                {
                    return zodiac[0];
                }
                else
                {
                    return zodiac[1];
                }
            case 5:
                if (days >= 1 & days <= 20)
                {
                    return zodiac[1];
                }
                else
                {
                    return zodiac[2];
                }
            case 6:
                if (days >= 1 & days <= 21)
                {
                    return zodiac[2];
                }
                else
                {
                    return zodiac[3];
                }
            case 7:
                if (days >= 1 & days <= 22)
                {
                    return zodiac[3];
                }
                else
                {
                    return zodiac[4];
                }
            case 8:
                if (days >= 1 & days <= 22)
                {
                    return zodiac[4];
                }
                else
                {
                    return zodiac[5];
                }
            case 9:
                if (days >= 1 & days <= 22)
                {
                    return zodiac[5];
                }
                else
                {
                    return zodiac[6];
                }
            case 10:
                if (days >= 1 & days <= 22)
                {
                    return zodiac[6];
                }
                else
                {
                    return zodiac[7];
                }
            case 11:
                if (days >= 1 & days <= 21)
                {
                    return zodiac[7];
                }
                else
                {
                    return zodiac[8];
                }
            case 12:
                if (days >= 1 & days <= 21)
                {
                    return zodiac[8];
                }
                else
                {
                    return zodiac[9];
                }
        }

        return string.Empty;

    }

    private int GetPhotosCount()
    {
        return (userPhotos != null && userPhotos.Rows.Count > 0) ? userPhotos.Rows.Count : 0;
    }



    #region ViewHistory

    private void GetOffers(string table)
    {
        bool is_history = (table == "offers_history") ;

            DataSet ds = db.GetDataSet(string.Format("select * from "+ table + " where (id_user_from = {0} and id_user_to = {1}) or (id_user_to = {0} and id_user_from = {1}) ", (int)MyUtils.GetUserField("id_user"), currentUser));

        string curUserName = currentUserData != null ? currentUserData["username"].ToString() : "";
        bool isMyOffer;
        if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow r in ds.Tables[0].Rows)
            {
                string amount = ((decimal)r["amount"]).ToString("C0");
                isMyOffer = (int)r["id_user_from"] == (int)MyUtils.GetUserField("id_user");
                int id_offer_state = (int)r["id_offer_state"];
                string counter = id_offer_state == 406 ? "counter " : "";

                DateTime d=DateTime.MinValue;
                
                if (r["time"] != DBNull.Value && Convert.ToDateTime(r["time"]) > d) d = Convert.ToDateTime(r["time"]);
                if (r["accepted"] != DBNull.Value && Convert.ToDateTime(r["accepted"]) > d) d = Convert.ToDateTime(r["accepted"]);
                if (r["rejected"] != DBNull.Value && Convert.ToDateTime(r["rejected"]) > d) d = Convert.ToDateTime(r["rejected"]);
                if (r["withdrawn"] != DBNull.Value && Convert.ToDateTime(r["withdrawn"]) > d) d = Convert.ToDateTime(r["withdrawn"]);
                if (r["updated"] != DBNull.Value && Convert.ToDateTime(r["updated"]) > d) d = Convert.ToDateTime(r["updated"]);

                if (!(r["rejected"] is DBNull))
                {
                    history.Add(new Tuple<DateTime, string>(d, string.Format("{0} rejected {1} offer", !isMyOffer ? "You" : curUserName, amount)));
                }
                else
                if (!(r["accepted"] is DBNull))
                {
                    history.Add(new Tuple<DateTime, string>(d, string.Format("{0} accepted {1} offer", !isMyOffer ? "You" : curUserName, amount)));
                }
                else
                if (!(r["withdrawn"] is DBNull))
                {
                    history.Add(new Tuple<DateTime, string>(d, string.Format("{0} withdrew " + (isMyOffer ? "" : "you ") + amount + " " + counter + "offer", isMyOffer ? "You" : curUserName)));
                }
                else
                    history.Add(new Tuple<DateTime, string>(d, string.Format("{0} sent " + (isMyOffer ? "" : "you ") + amount + " " + counter + "offer", isMyOffer ? "You" : curUserName)));

            }

            isAnyHistory = true;
        }


    }

    private void GetLikes()
    {
        DataSet ds = db.CommandBuilder_LoadDataSet(string.Format("select * from winks where (id_user = {0} and id_user_child = {1}) or (id_user_child = {0} and id_user = {1})", (int)MyUtils.GetUserField("id_user"), currentUser));
        string curUserName = currentUserData != null ? currentUserData["username"].ToString() : "";
        bool isMyLike;

        if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow r in ds.Tables[0].Rows)
            {
                isMyLike = (int)r["id_user"] == (int)MyUtils.GetUserField("id_user");
                history.Add(new Tuple<DateTime, string>((DateTime)r["time"], string.Format("{0} winked at {1}", isMyLike ? "You" : curUserName, isMyLike ? curUserName : "You")));
            }

            isAnyHistory = true;
        }


    }

    private void GetFavorites()
    {
        DataSet ds = db.CommandBuilder_LoadDataSet(string.Format("select * from favorites where (id_user = {0} and id_user_child = {1}) or (id_user_child = {0} and id_user = {1})", (int)MyUtils.GetUserField("id_user"), currentUser));
        string curUserName = currentUserData != null ? currentUserData["username"].ToString() : "";
        bool isMyFavorite;

        if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            foreach (DataRow r in ds.Tables[0].Rows)
            {
                isMyFavorite = (int)r["id_user"] == (int)MyUtils.GetUserField("id_user");
                history.Add(new Tuple<DateTime, string>((DateTime)r["time"], string.Format("{0} favorited {1}", isMyFavorite ? "You" : curUserName, isMyFavorite ? curUserName : "You")));
            }

            isAnyHistory = true;
        }


    }

    private void GetMessages()
    {
        int id_user_unlocked = db.ExecuteScalarInt(string.Format("select id_user_unlocked from offers where (id_user_from = {0} and id_user_to = {1}) or (id_user_to = {0} and id_user_from = {1})", (int)MyUtils.GetUserField("id_user"), currentUser), 0);

        DataSet ds = db.GetDataSet(string.Format("select * from messages where (id_user_from = {0} and id_user_to = {1}) or (id_user_to = {0} and id_user_from = {1})", (int)MyUtils.GetUserField("id_user"), currentUser));

        string curUserName = currentUserData != null ? currentUserData["username"].ToString() : "";
        bool isMyMessage = false;

        if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
        {
            foreach(DataRow r in ds.Tables[0].Rows)
            {
                isMyMessage = (int)r["id_user_from"] == (int)MyUtils.GetUserField("id_user");
                string mess = r["text"].ToString();
                if (!isMyMessage && id_user_unlocked == 0 && MyUtils.IsMale) mess = "**************** [Message is locked. Please unlock messaging]";
                history.Add(new Tuple<DateTime, string>((DateTime)r["time"], string.Format("{0} sent message: <span style =\"color:blue\">{1} </span>", isMyMessage ? "You" : curUserName, mess)));

            }

            isAnyHistory = true;
          
        }

        
    }

    protected void upHistory_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            GetOffers("offers");
            GetOffers("offers_history");
            GetLikes();
            GetFavorites();
            GetMessages();

            if (!isAnyHistory)
            {
                ltNoHistory.Visible = true;
                lblHistory.Visible = false;
            }
            else
            {
                if(history.Count > 0)
                {
                    history = history.OrderByDescending(x => x.Item1).ToList();
                    foreach (var r in history)
                    {
                        lblHistory.Text += MyUtils.TimeAgo(r.Item1) + "<span style = \"color:black\"> " + r.Item2.ToString() + "</span><br>";
                    }
                }
            }

        }
    }

    #endregion

    protected void btnBan_Click(object sender, EventArgs e)
    {
        try
        {
            DataSet ds = db.CommandBuilder_LoadDataSet(string.Format("select * from users where id_user={0}", currentUser));
            DataRow userRow = ds.Tables[0].Rows[0];

            if ((sender as LinkButton).Text == "Ban")
            {
                userRow["status"] = -2;

                db.CommandBuilder_SaveDataset();

                btnBan.Text = btnBanMobile.Text = "Unban";
            }
            else
            {
                userRow["status"] = 1;

                db.CommandBuilder_SaveDataset();

                btnBan.Text = btnBanMobile.Text = "Ban";
            }
        }
        finally
        {
            db.CommandBuilder_Disconnect();
        }
    }

    protected string GetImageSize(DataRow uRow)
    {
        string imageSize = "313x313";

        if(!(uRow["image_height"] is DBNull) && !(uRow["image_width"] is DBNull))
        {
            imageSize = uRow["image_width"].ToString() + "x" + uRow["image_height"].ToString();
            if (imageSize=="0x0") imageSize = "313x313";
        }

        return imageSize;
    }
}