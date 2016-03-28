﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Messages_Chat : System.Web.UI.Page
{
    public int ID_USER;

    public DataRow R;

    static DataTable SaveMessage2DBAndSelect(int id_user_from, int id_user_to, string message, string gift_list, int id_offer)
    {

        DB_Helper db = new DB_Helper();
        return db.GetDataSet("insert into messages (id_user_from,id_user_to,text,gift_list,id_offer) OUTPUT inserted.* values (" + id_user_from + "," + id_user_to + "," + MyUtils.safe(message) + "," + MyUtils.safe(gift_list) + "," + id_offer + ");").Tables[0];
    }

    static DataTable GetMessagesForUser(int id_user, int id_user_with, int start_with_id = 0)
    {
        //IsFromMe gives 1 if the message was sent my me.
        DB_Helper db = new DB_Helper();

        string sql = "select " +
            "(SELECT top 1 [username] FROM [dbo].[Users] where [id_user] = m.id_user_from) FromUser," +
            "(SELECT top 1 [username] FROM[dbo].[Users] where[id_user] = m.id_user_to) ToUser, " +
            "case when id_user_from=" + id_user +
            " then 1 else 0 end as IsFromMe, * from messages m where ((id_user_from=" +
            id_user + " and id_user_to=" + id_user_with + ") or (id_user_to=" + id_user + " and id_user_from=" + id_user_with + ")) and m.[id_message] >= " + start_with_id + " order by [time] desc";
        sql += "; update messages set is_new = 0 where id_user_to =" + id_user + " and id_user_from = " + id_user_with +" and is_new = 1 and [id_message] >= " + start_with_id;
        return db.GetDataSet(sql).Tables[0];
    }
    public DataRow Offer;
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Form.Attributes["data-form"] = "message";

        note.Visible = MyUtils.IsMale;

        ID_USER = (int)MyUtils.GetUserField("ID_USER"); //will redirect to login page if not logged in
        int ID_USER_CHATWITH = Convert.ToInt32(Request.QueryString["id"]);

        DB_Helper db = new DB_Helper();

        int id_offer = db.ExecuteScalarInt("exec CAN_MESSAGE_WITH " + ID_USER + "," + ID_USER_CHATWITH, 0);
        if (id_offer == 0)
        {
            Response.Clear();
            Response.Write("You don't have permission to send messages to this user.");
            Response.End();
        }

        R = db.GetRow("exec GET_USER_PROFILE " + ID_USER + "," + ID_USER_CHATWITH);
        if (R==null)
        {
            Response.Clear();
            Response.Write("This user doesn't exist.");
            Response.End();
        }

        Offer = db.GetRow("select amount from offers where (id_user_to=" + ID_USER + " and id_user_from=" + ID_USER_CHATWITH + ") or (id_user_to=" + ID_USER_CHATWITH + " and id_user_from=" + ID_USER + ")");





        //do some magic here with  ID_USER and ID_USER_CHATWITH

        //.......................................................


        //Example on how to insert message to DB
        //SaveMessage2DB(10002, 10003, "testing.... ", "1,2,3,4");

        //Example on how to get messages for user pair
        //DataTable T = GetMessagesForUser(10002, 10003);

    }

    [WebMethod]
    public static Message SendMessage(string message, string toUser, string giftIds)
    {
        DB_Helper db = new DB_Helper();
        var fromUser = MyUtils.ID_USER;



        message = MyUtils.StripHTML(message);
        giftIds = MyUtils.StripHTML(giftIds);

        int id_offer = db.ExecuteScalarInt("exec CAN_MESSAGE_WITH " + Convert.ToInt32(fromUser) + "," + Convert.ToInt32(toUser), 0);
        if (id_offer == 0)
        {
            Message m = new Message();
            m.Text = "You don't have permission to send messages to this user.";
            return m;
        }

        if (message.Trim() == "") return null;


        var table = SaveMessage2DBAndSelect(fromUser, Convert.ToInt32(toUser), message, giftIds, id_offer);


        DB_Helper.InvalidateCache("TOPCOUNTS_" + MyUtils.ID_USER);
        DB_Helper.InvalidateCache("TOPCOUNTS_" + Convert.ToInt32(toUser));

        var query = from p in table.AsEnumerable()
                    select new Message
                    {
                        Id = p.Field<int>("id_message"),
                        Text = p.Field<string>("text"),
                        From = new User
                        {
                            Name = "You",
                            Id = p.Field<int>("id_user_from")
                        },
                        To = new User
                        {
                            Name = "Female123", //TODO
                            Id = p.Field<int>("id_user_from")
                        },
                        DateTime = p.Field<DateTime>("time"),
                        IsFromMe = true
                    };
        return query.First();
    }

    [WebMethod]
    public static List<Message> GetChatHistory(string toUser, int lastMessageId)
    {

        if (!MyUtils.IsLoggedIn())
        {
            List<Message> ml = new List<Message>();
            ml.Add(new Message());
            ml[0].Text = "REDIRTOLOGIN";
            return ml;
        }

        MyUtils.UserIsOnline();


        int userId = (int)MyUtils.GetUserField("ID_USER"); //will redirect to login page if not logged in

        System.Web.HttpContext.Current.Session["Heartbeat"] = DateTime.Now;

        DataTable messages = GetMessagesForUser(userId, Convert.ToInt32(toUser), ++lastMessageId);

        var query = from p in messages.AsEnumerable()
                    select new Message
                    {
                        Id = p.Field<int>("id_message"),
                        Text = p.Field<string>("text"),
                        From = new User
                        {
                            Name = p.Field<int>("id_user_from") == userId ? "You" : p.Field<string>("FromUser"),
                            Id = p.Field<int>("id_user_from")
                        },
                        To = new User
                        {
                            Name = p.Field<int>("id_user_from") == userId ? "You" : p.Field<string>("FromUser"),
                            Id = p.Field<int>("id_user_from")
                        },
                        DateTime = p.Field<DateTime>("time"),
                        IsFromMe = p.Field<int>("IsFromMe") == 1,
                        Gifts = p.Field<string>("gift_list")
                    };
        
        return query.Take(20).OrderBy(r => r.DateTime).ToList();
    }

    public class Message
    {
        public string Text { get; set; }
        [IgnoreDataMember]
        public DateTime DateTime { get; set; }
        public string Sent
        {
            get
            {
                return DateTime.ToShortTimeString();
            }
        }
        public User From { get; set; }
        public User To { get; set; }
        public int Id { get; set; }
        public bool IsFromMe { get; set; }
        public string Gifts { get; set; }
    }

    public class User
    {
        public string Name { get; set; }
        public int Id { get; set; }
    }
}