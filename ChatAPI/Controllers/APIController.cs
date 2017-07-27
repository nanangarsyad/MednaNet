﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;


namespace ChatAPI.Controllers
{

    public class APIController : ApiController
    {
        //http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api#restful


        //[Route("api/chat/groups")]
        //[HttpGet]
        // public IHttpActionResult GetGroups(string installKey)
        // {

        // }


        //Install key should be passed through user name field of HTTP Basic Auth

        //api/v1/channels/{channel_id}/messages
        //api/v1/groups/{group_id}/message


        // [Route("api/chat/messages/{from}")]
        //[HttpGet]
        // public IHttpActionResult GetMessages


        [Route("api/v1/installs")]
        [HttpGet]
        public IHttpActionResult GetInstalls()
        {
            IEnumerable<string> headerValues = Request.Headers.GetValues("Authorization");
            string installKey = headerValues.FirstOrDefault();

            List<NetplayAPIClient.Installs> installs = null;

            if (installKey == "supersecret")
            {
                using (Models.MedLaunchChatEntities db = new Models.MedLaunchChatEntities())
                {
                    installs = (from q in db.installs
                                   select new NetplayAPIClient.Installs()
                                   {
                                       banned = q.banned,
                                       code = q.code,
                                       lastCheckin = q.last_checkin,
                                       registeredOn = q.registered_on,
                                       tempBan = q.temp_ban,
                                       tempBanEnd = q.temp_ban_end,
                                       username = q.username
                                   }).ToList();
                }
            }

            return Ok(installs);

        }

        [Route("api/v1/installs")]
        [HttpPost]
        public IHttpActionResult CreateInstall()
        {
            string guid = Guid.NewGuid().ToString();

            using (Models.MedLaunchChatEntities db = new Models.MedLaunchChatEntities())
            {
                Models.install newInstall = new Models.install();
                newInstall.banned = false;
                newInstall.code = guid;
                newInstall.last_checkin = DateTime.Now;
                newInstall.registered_on = DateTime.Now;
                newInstall.username = "";

                db.installs.Add(newInstall);
                db.SaveChanges();
            }

            return Ok(guid);
        }

        [Route("api/v1/installs/{installKey}")]
        [HttpGet]
        public IHttpActionResult GetInstall(string installKey)
        {
            //IEnumerable<string> headerValues = Request.Headers.GetValues("Authorization");
            //string installKey2 = headerValues.FirstOrDefault();

            NetplayAPIClient.Installs install = null;

            using (Models.MedLaunchChatEntities db = new Models.MedLaunchChatEntities())
            {
                install = (from q in db.installs
                           where q.code == installKey
                           select new NetplayAPIClient.Installs()
                           {
                               id = q.id,
                               banned = q.banned,
                               code = q.code,
                               lastCheckin = q.last_checkin,
                               registeredOn = q.registered_on,
                               tempBan = q.temp_ban,
                               tempBanEnd = q.temp_ban_end,
                               username = q.username
                           }).FirstOrDefault();
            }

            return Ok(install);
        }

        [Route("api/v1/groups")]
        [HttpGet]
        public IHttpActionResult GetGroups()
        {

            IEnumerable<string> headerValues = Request.Headers.GetValues("Authorization");
            string installKey = headerValues.FirstOrDefault();
            
            

            List<NetplayAPIClient.Groups> groups = null;

            using (Models.MedLaunchChatEntities db = new Models.MedLaunchChatEntities())
            {
                var install = (from q in db.installs
                               where q.code == installKey
                               select q).FirstOrDefault();

                if (install != null)
                {
                    

                    groups = (from q in db.group_members
                                where q.install_id == install.id
                                select new NetplayAPIClient.Groups()
                                {
                                    groupDescription = q.@group.group_description,
                                    groupName = q.@group.group_name,
                                    groupOwner = q.@group.group_owner,
                                    id = q.id
                                } ).ToList();

   
                }
            }

            return Ok(groups.ToList());
        }

        [Route("api/v1/groups")]
        [HttpPost]
        public IHttpActionResult CreateGroup(NetplayAPIClient.Groups group)
        {
            //Use installKey to look up the install ID. 
            var APIReturn = new Models.APIReturn();

            IEnumerable<string> headerValues = Request.Headers.GetValues("Authorization");
            string installKey = headerValues.FirstOrDefault();


            using (Models.MedLaunchChatEntities db = new Models.MedLaunchChatEntities())
            {
                var install = (from q in db.installs
                           where q.code == installKey
                           select q).FirstOrDefault();

                if(install != null)
                {
                    Models.group newGroup = new Models.group();
                    newGroup.group_description = group.groupDescription;
                    newGroup.group_name = group.groupName;
                    newGroup.group_owner = group.groupOwner;

                    if(newGroup.group_name.Length > 20)
                    {
                        newGroup.group_name = newGroup.group_name.Substring(0, 19);
                    }

                    db.groups.Add(newGroup);

                    try
                    {
                        db.SaveChanges();
                        APIReturn.returnMessage = "Group created.";
                    }
                    catch(Exception e)
                    {
                        APIReturn.returnMessage = "Could not create group.";
                        return new System.Web.Http.Results.ExceptionResult(e, this);
                    }

                    Models.group_members groupMember = new Models.group_members();
                    groupMember.awaiting_invite_confrim = false;
                    groupMember.group_id = newGroup.id;
                    groupMember.install_id = install.id;
                    db.group_members.Add(groupMember);


                    try
                    {
                        db.SaveChanges();
                        APIReturn.returnMessage += "| Install added to group";
                    }
                    catch (Exception e)
                    {
                        APIReturn.returnMessage = "Could not add install to group.";
                        return new System.Web.Http.Results.ExceptionResult(e, this);
                    }
                }
                else
                {
                    APIReturn.returnMessage = "Install not found";
                }
            }

            return Ok();
        }
        



        [Route("api/v1/groups/{id}/messages")]
        [HttpPost]
        public IHttpActionResult CreateMessage(int id, NetplayAPIClient.Messages message)
        {
            IEnumerable<string> headerValues = Request.Headers.GetValues("Authorization");
            string installKey = headerValues.FirstOrDefault();

            var APIReturn = new Models.APIReturn();
            APIReturn.returnMessage = "something";
            using (Models.MedLaunchChatEntities db = new Models.MedLaunchChatEntities())
            {
                var install = (from q in db.installs
                              where q.code == installKey
                               select q).FirstOrDefault();

                if(install != null)
                {
                    if (install.banned)
                    {
                        //Return user is perm banned
                        APIReturn.returnMessage = "You have been banned from chat.";
                    }
                    else
                    {
                        if (install.temp_ban)
                        {
                            //Return user is temp banned, pass back temp_ban_end for when ban will end
                            APIReturn.returnMessage = "You have been temporarily banned from chat. This ban will end on " + install.temp_ban_end.ToString();
                        }
                        else
                        {

                            var newRecord = new Models.message();

                            newRecord.code = message.code;
                            newRecord.message1 = message.message;
                            newRecord.name = install.username;
                            newRecord.posted_on = DateTime.Now;
                            newRecord.channel = id;

                            db.messages.Add(newRecord);
                            db.SaveChanges();

                        }
                    }
                }
                else
                {
                    //Return can't find install
                    APIReturn.returnMessage = "Unable to find install.";
                }

               
            }

            return Ok(APIReturn);

           
        }

        [Route("api/v1/groups/{id}/messages")]
        [HttpGet]
        public IHttpActionResult GetMessages(int id)
        {
            IEnumerable<string> headerValues = Request.Headers.GetValues("Authorization");
            string installKey = headerValues.FirstOrDefault();


            List<NetplayAPIClient.Messages> messages = null;

            using (Models.MedLaunchChatEntities db = new Models.MedLaunchChatEntities())
            {
                var install = (from q in db.installs
                               where q.code == installKey
                               select q).FirstOrDefault();

                if (install != null)
                {

                    /*
                     * var b = from row in a
        where a.Brow.Any(b => b.name == "Joe") &&
              a.Brow.Crow.Any(c => c.name == "Kim")
        select row;
        
                     var licenses = context.LicenseUsers
  .Include(lu => lu.License.Product)
  .Where(lu => lu.User.Id == 1)
  .Select(lu => new { lic = lu.License, prod = lu.License.Product } )
  .AsEnumerable()  // Here we have forced the SQL to include the product too
  .Select(lu => lu.lic)
  .ToList(); // Then we select (locally) only the license for convenience 
             // (so that our collection is of type License)
             // Since the SQL Query actually loaded the products
             // the references will be ok
                     
                     
                    db.Schools
        .Where(x => x.Name.Contains("Some Value"))
        .Include(x => x.Schools.Where(x => x.MiddleName.Contains("SomeValue")))
        .ToList();
                     
                     */
                    var m = from q in db.groups
                            where q.id == id && q.group_members.Select(b => b.install_id).Contains(install.id)
                            select q.messages;

                    

                   // db.groups
        //.Where(x => x.id == id && x.group_members.Select(b => b.install_id == install.id)
       // .
       // .ToList();

                    //This should return all message for every group user is part of?
                    //var messages1 = db.messages.Where(x => x.group.group_members.Select(b => b.install_id).Contains(install.id));

                    //trying to get message for a group. Need to make sure that the install is allowed to see messages in group

                    /* messages = (from q in db.messages
                               where q.
                               select new NetplayAPIClient.Groups()
                               {
                                   groupDescription = q.@group.group_description,
                                   groupName = q.@group.group_name,
                                   groupOwner = q.@group.group_owner,
                                   id = q.id
                               }).ToList();*/


                }
            }

            return Ok(messages.ToList());
        }

        
    }
}