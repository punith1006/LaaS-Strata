# Email Draft: Request — Ubuntu Repository Access Blocked by Web Filter

---

**To:** KSRCE IT Admin  
**From:** Punith, LaaS Platform Deployment  
**Date:** May 2, 2026  
**Subject:** Request: Ubuntu Repository Access Blocked by Web Filter — AI Lab Servers  

---

Dear IT Team,

I'm writing to report that `apt` package operations are failing on all AI lab servers (ai1, ai2, ai4). These operations were working normally through April 30 but are now returning 403 Forbidden and 307 redirect errors.

The issue is caused by the Sophos/Cyberoam web category filter (Category 68) on the gateway at `20.1.1.1:8090`, which is blocking access to Ubuntu package repositories (`archive.ubuntu.com`, `security.ubuntu.com`, etc.). I've confirmed this through direct `curl` tests — non-repository traffic (e.g., google.com) works fine, while repository traffic is intercepted and blocked.

This is blocking all server setup work, including NVIDIA driver installation, Docker setup, and security updates, effectively halting the LaaS GPU compute platform deployment.

Could you please review the Sophos web filter policy and whitelist the domains listed in the attached incident report? I'm available for a call or remote session if that would help.

Thank you for your time and support.

Best regards,  
Punith  
LaaS Platform Deployment  

**Attachment:** [KSRCE-Network-Proxy-Issue-Report.md](./KSRCE-Network-Proxy-Issue-Report.md)
