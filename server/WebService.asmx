<%@ WebService Language="C#" Class="WebService" %>

using System;
using System.Collections.Generic;
using System.Net;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;

[WebService(Namespace = "http://pricepointdate.com/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    DB_Helper db = new DB_Helper();


    void InvalidateCacheTOPCOUNTS(int id_user)
    {
        DB_Helper.InvalidateCache("TOPCOUNTS_" + id_user);
    }


    [WebMethod(EnableSession = true)]
    public string AcceptOffer(int id_offer)
    {
        int id = 0;
        if (!MyUtils.IsLoggedIn()) return "ERROR: Please log in.";
        try
        {
            //Get IDs and Ensure security
            System.Data.DataRow R = db.GetRow("select id_user_from,id_user_to from offers where id_offer=" + id_offer);
            int id_user_from = Convert.ToInt32(R["id_user_from"]);
            int id_user_to = Convert.ToInt32(R["id_user_to"]);
            if (id_user_from != MyUtils.ID_USER && id_user_to != MyUtils.ID_USER)
            {
                return "ERROR: Permission denied.";
            }

            db.Execute("exec ARCHIVE_OFFER " + id_offer);
            db.Execute("update offers set accepted=getdate(), id_offer_state=404,updated=getdate() where id_offer=" + id_offer);
            InvalidateCacheTOPCOUNTS(id_user_from);
            InvalidateCacheTOPCOUNTS(id_user_to);
            id = id_user_from;
            if (id == MyUtils.ID_USER) id = id_user_to;
            RWorker.AddToEmailQueue ("EMAIL_OFFERACCEPTED", id_user_from, id_user_to);
        }
        catch (Exception e)
        {
            return "ERROR:" + e.Message;
        }
        if (MyUtils.IsFemale)
        {
            Session["message"] = "OK: You accepted the offer.";
            return "OK: REDIR:/Account/Chat?id=" + id;
        }
        else
        {
            string re=HttpContext.Current.Request.ServerVariables["HTTP_REFERER"];
            if (re.Contains("/Offers"))
            {
                Session["message"] = "OK: You accepted the offer.";
                return "OK: REDIR:/Account/Offers?type=Accepted";
            }
            if (re.Contains("/ViewProfile"))
            {
                Session["message"] = "OK: You accepted the offer.";
                return "OK: REFRESH";
            }

        }
        return "OK: You accepted the offer.";
    }

    [WebMethod(EnableSession = true)]
    public string RejectOffer(int id_offer)
    {
        return RejectOfferV2(id_offer, 0);
    }

    [WebMethod(EnableSession = true)]
    public string RejectOfferV2(int id_offer, int reason)
    {
        if (!MyUtils.IsLoggedIn()) return "ERROR: Please log in.";
        try
        {
            //Get IDs and Ensure security
            System.Data.DataRow R = db.GetRow("select id_user_from,id_user_to from offers where id_offer=" + id_offer);
            int id_user_from = Convert.ToInt32(R["id_user_from"]);
            int id_user_to = Convert.ToInt32(R["id_user_to"]);
            if (id_user_from != MyUtils.ID_USER && id_user_to != MyUtils.ID_USER)
            {
                return "ERROR: Permission denied.";
            }

            db.Execute("exec ARCHIVE_OFFER " + id_offer);
            db.Execute("update offers set id_offer_state=405, rejected=getdate(),rejected_reason=" + reason + ",updated=getdate() where id_offer=" + id_offer);
            InvalidateCacheTOPCOUNTS(id_user_from);
            InvalidateCacheTOPCOUNTS(id_user_to);
            RWorker.AddToEmailQueue ("EMAIL_OFFERREJECTED", id_user_from, id_user_to);
        }
        catch (Exception e)
        {
            return "ERROR: " + e.Message;
        }

        string re=HttpContext.Current.Request.ServerVariables["HTTP_REFERER"];
        //        if (re.Contains("/Offers.aspx"))
        //      {
        //        Session["message"] = "OK: You rejected the offer.";
        //      return "OK: REDIR:/Account/Offers.aspx?type=Accepted";
        // }
        if (re.Contains("/ViewProfile"))
        {
            Session["message"] = "OK: You rejected the offer.";
            return "OK: REFRESH";
        }
        return "OK";
    }

    [WebMethod(EnableSession = true)]
    public string SendWink(int id_user)
    {
        if (!MyUtils.IsLoggedIn()) return "ERROR: Please log in.";
        try
        {
            db.Execute("if not exists(select * from winks where id_user=" + MyUtils.ID_USER + " and id_user_child=" + id_user + ") insert into winks (id_user,id_user_child) values (" + MyUtils.ID_USER + "," + id_user + ")");
            RWorker.AddToEmailQueue("EMAIL_WINK", id_user, MyUtils.ID_USER, true);
            return "OK: Wink was sent.";
        }
        catch (Exception e)
        {
            return "ERROR:" + e.Message;
        }

    }

    [WebMethod(EnableSession = true)]
    public string MakeOffer(int id_user, double amount, int[] gifts)
    {
        if (!MyUtils.IsLoggedIn()) return "ERROR: Please log in.";
        try
        {
            int todaysent = db.ExecuteScalarInt("select count(*) from offers where datediff(day, getdate(), time) = 0 and id_user_from=" + MyUtils.ID_USER);

            if (todaysent >= 20) return "ERROR: You have reached maximum offers per day limit. Please wait untill tomorrow.";
            //int exists = db.ExecuteScalarInt("select count(*) from offers where id_user_to=" + id_user + " and id_user_from=" + MyUtils.ID_USER);
            //if (exists > 0) return "ERROR: You have already sent " + (amount == 0 ? "wink" : "offer") + " to this user.";


            string s = MakeOfferV2("bigapple", MyUtils.ID_USER, id_user, amount, gifts);

            InvalidateCacheTOPCOUNTS(MyUtils.ID_USER);
            InvalidateCacheTOPCOUNTS(id_user);

            return s;

        }
        catch (Exception e)
        {
            return "ERROR:" + e.Message;
        }

    }

    void InvalidateTopCountsForOffer(int id_offer)
    {
        System.Data.DataRow R = db.GetRow("select id_user_from,id_user_to from offers where id_offer=" + id_offer);

        InvalidateCacheTOPCOUNTS(Convert.ToInt32(R["id_user_from"]));
        InvalidateCacheTOPCOUNTS(Convert.ToInt32(R["id_user_to"]));

    }


    [WebMethod(EnableSession = true)]
    public string WithdrawOffer(int id_offer)
    {
        if (!MyUtils.IsLoggedIn()) return "ERROR: Please log in.";
        try
        {
            //Get IDs and Ensure security
            System.Data.DataRow R = db.GetRow("select id_user_from,id_user_to from offers where id_offer=" + id_offer);
            int id_user_from = Convert.ToInt32(R["id_user_from"]);
            int id_user_to = Convert.ToInt32(R["id_user_to"]);
            if (id_user_from != MyUtils.ID_USER && id_user_to != MyUtils.ID_USER)
            {
                return "ERROR: Permission denied.";
            }

            db.Execute("exec ARCHIVE_OFFER " + id_offer);
            db.Execute("update offers set withdrawn=getdate(), id_offer_state=411,updated=getdate() where id_offer=" + id_offer);
            db.Execute("exec ARCHIVE_OFFER " + id_offer);
            db.Execute("delete offers where id_offer=" + id_offer);

            InvalidateCacheTOPCOUNTS(id_user_from);
            InvalidateCacheTOPCOUNTS(id_user_to);

            return "OK: Offer has been withdrawn";
        }
        catch (Exception e)
        {
            return "ERROR:" + e.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string CounterOffer(int id_offer, double amount)
    {
        if (!MyUtils.IsLoggedIn()) return "ERROR: Please log in.";
        try
        {

            //Get IDs and Ensure security
            System.Data.DataRow R = db.GetRow("select id_user_from,id_user_to from offers where id_offer=" + id_offer);
            int id_user_from = Convert.ToInt32(R["id_user_from"]);
            int id_user_to = Convert.ToInt32(R["id_user_to"]);
            if (id_user_from != MyUtils.ID_USER && id_user_to != MyUtils.ID_USER)
            {
                return "ERROR: Permission denied.";
            }

            int id = id_user_to;
            if (id == MyUtils.ID_USER) id = id_user_from;
            db.Execute("exec ARCHIVE_OFFER " + id_offer);
            db.Execute("update offers set id_offer_to=" + id + ",id_offer_from=" + MyUtils.ID_USER + ", id_offer_state=406,updated=getdate(),amount=" + amount + " where id_offer=" + id_offer);
            InvalidateTopCountsForOffer(id_offer);
            return "OK: Counter Offer was Sent";
        }
        catch (Exception e)
        {
            return "ERROR:" + e.Message;
        }
    }

    static object UnlockConvLock = new object();

    [WebMethod(EnableSession = true)]
    public string UnlockOffer(int id_offer)
    {
        if (!MyUtils.IsLoggedIn()) return "ERROR: Please log in.";

        //Get IDs and Ensure security
        System.Data.DataRow R = db.GetRow("select id_user_from,id_user_to from offers where id_offer=" + id_offer);
        int id_user_from = Convert.ToInt32(R["id_user_from"]);
        int id_user_to = Convert.ToInt32(R["id_user_to"]);
        if (id_user_from != MyUtils.ID_USER && id_user_to != MyUtils.ID_USER)
        {
            return "ERROR: Permission denied.";
        }


        lock (UnlockConvLock)
        {
            string sql = "exec ULOCK_OFFER " + id_offer + "," + MyUtils.ID_USER;
            int i = db.ExecuteScalarInt(sql, 0);
            return "OK";
        }
    }

    [WebMethod(EnableSession = true)]
    public string Favorite(int id_user, bool on_off)
    {
        try
        {
            if (!MyUtils.IsLoggedIn()) return "ERROR: Please log in.";

            string username= db.ExecuteScalarString("select username from users where id_user=" + id_user);
            if (on_off)
            {
                db.Execute("if not exists(select * from favorites where id_user=" + MyUtils.ID_USER + " and id_user_child=" + id_user + ") insert into favorites (id_user,id_user_child) values (" + MyUtils.ID_USER + "," + id_user + ")");

                RWorker.AddToEmailQueue("EMAIL_FAVORITED_" + (MyUtils.IsFemale ? "HER" : "HIM"), id_user , MyUtils.ID_USER, true);

                return "OK: "+username + " was favorited.";
            }
            db.Execute("delete favorites where id_user=" + MyUtils.ID_USER + " and id_user_child=" + id_user);
            return "OK: "+ username + " was unfavorited.";
        }
        catch (Exception e)
        {
            return "ERROR:" + e.Message;
        }
    }


    string Gifts(int[] gifts)
    {
        string s = "";
        if (gifts.Length == 0) return "no gifts";
        foreach (int i in gifts)
        {
            if (s != "") s += ", ";
            s += i;
        }
        return s;
    }

    [WebMethod]
    public string DownloadImageFromURLAndSave(string url)
    {
        string guid = "";
        try
        {
            string f = System.Web.HttpContext.Current.Server.MapPath("~/UserImages") + "\\" + DateTime.Now.Ticks.ToString() + ".jpg";
            using (WebClient c = new WebClient())
            {
                c.DownloadFile(url, f);
                try
                {
                    using (Stream s = c.OpenRead(f))
                    {
                        guid = RobsCommonUtils.AmazonS3.SaveImageToFileandAmazon(s, "~/UserImages");
                    }
                }
                finally
                {
                    File.Delete(f);
                }
            }
        }
        catch
        {

        }
        return guid;

    }

    public string MakeOfferV2(string pass, int id_user_from, int id_user_to, double amount, int[] gifts)
    {
        if (pass != "bigapple") return "";

        DB_Helper db = new DB_Helper();


        if (amount > 500) return "ERROR: You can't offer more than $500.";
        if (amount < 50) return "ERROR: You can't offer less than $50.";

        try
        {
            Gifts g = new global::Gifts(gifts);

            string giftss = g.ToString();

            int id_offer = db.ExecuteScalarInt("select id_offer from offers where id_user_from=" + id_user_to + " and id_user_to=" + id_user_from);

            //this is Counter offer
            if (id_offer > 0)
            {
                int amount_old = db.ExecuteScalarInt("select amount from offers where id_offer=" + id_offer);
                if (MyUtils.IsFemale)
                {
                    if (amount_old >= amount) return "ERROR: Your counter offer needs to be more than $" + amount_old;
                }
                else
                {
                    if (amount_old <= amount) return "ERROR: Your counter offer needs to be less than $" + amount_old;
                }
                db.Execute("exec ARCHIVE_OFFER " + id_offer);
                db.Execute("update offers set rejected=null,id_user_from=" + id_user_from + ",id_user_to=" + id_user_to + ",id_offer_state=406,updated=getdate(), amount=" + amount + ",gifts=" + MyUtils.safe(giftss) + " where id_offer_state<>404 and id_offer=" + id_offer);
                //send counter offer email
                RWorker.AddToEmailQueue("EMAIL_COUNTEROFFER", id_user_to, id_user_from);
            }
            else
            {
                id_offer = db.ExecuteScalarInt("select id_offer from offers where id_user_to=" + id_user_to + " and id_user_from=" + id_user_from);
                if (id_offer > 0)
                {
                    int amount_old = db.ExecuteScalarInt("select amount from offers where id_offer=" + id_offer);
                    if (MyUtils.IsFemale)
                    {
                        if (amount_old >= amount) return "ERROR: Your counter offer needs to be more than $" + amount_old;
                    }
                    else
                    {
                        if (amount_old <= amount) return "ERROR: Your counter offer needs to be less than $" + amount_old;
                    }
                    //update my old (rejected) offer
                    db.Execute("exec ARCHIVE_OFFER " + id_offer);
                    db.Execute("update offers set amount=" + amount + ",rejected=null,id_offer_state=403,updated=getdate() where id_offer=" + id_offer);
                }
                else
                {
                    id_offer = db.ExecuteScalarInt("insert into offers (id_user_to,id_user_from,amount,gifts) values (" + id_user_to + "," + id_user_from + "," + amount + "," + MyUtils.safe(giftss) + ");select @@identity", 0);
                }
                //send offer email
                RWorker.AddToEmailQueue("EMAIL_NEWOFFER", id_user_to, id_user_from);
            }


            if (id_offer > 0)
            {
                g.AddGifts2User(MyUtils.ID_USER, id_user_to);


                string re = HttpContext.Current.Request.ServerVariables["HTTP_REFERER"];
                if (re.Contains("/ViewProfile"))
                {
                    Session["message"] = "OK: Your offer has been sent!";
                    return "OK: REFRESH";
                }


                return "OK. Your offer has been sent!" + (!g.IsEmpty ? "|" + MyUtils.Credits : "");
            }

        }
        catch (Exception ex)
        {
            return "ERROR: " + ex.Message;
        }

        return "ERROR: offer not sent";
    }


    [WebMethod(EnableSession = true)]
    public string Unblock(string id_user)
    {
        try
        {
            if (!MyUtils.IsLoggedIn()) return "ERROR: Please log in.";

            string username= db.ExecuteScalarString("select username from users where id_user=" + id_user);

            if (db.Execute(string.Format("delete from blocks where id_user_child={0} and id_user = {1}", MyUtils.ID_USER, id_user)) > 0)
            {
                return "OK: "+ username + " was unblocked.";
            }
            return "ERROR: Unknown";
        }
        catch (Exception e)
        {
            return "ERROR:" + e.Message;
        }
    }
}
