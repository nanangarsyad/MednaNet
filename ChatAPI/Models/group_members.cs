//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace MednaNetAPI.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class group_members
    {
        public int id { get; set; }
        public int group_id { get; set; }
        public int install_id { get; set; }
        public bool awaiting_invite_confrim { get; set; }
    
        public virtual group group { get; set; }
    }
}
