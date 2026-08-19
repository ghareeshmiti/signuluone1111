import io, json, textwrap

HEAD = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{title}</title>
  <meta name="description" content="{desc}">
  <link rel="canonical" href="https://signulu.com/{slug}.html">
  <link rel="icon" type="image/png" href="/img/signuluone-logo.png">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&display=swap" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="/css/tokens.css" rel="stylesheet">
  <link href="/css/theme.css" rel="stylesheet">
</head>
<body data-page="industries">
  <header class="site-header" data-include="/partials/header.html"></header>

  <main id="main">
"""

FOOT = """  </main>

  <footer class="site-footer" data-include="/partials/footer.html"></footer>
  <div data-modal="/partials/product-modal.html"></div>
  <div data-modal="/partials/trial-modal.html"></div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="/js/include.js"></script>
</body>
</html>
"""

TRIAL = "https://app.signulu.com/account/register"


def page(d):
    out = io.StringIO()
    out.write(HEAD.format(**d))
    # hero
    out.write(f"""    <section class="hero hero-compact" data-testid="{d['slug']}-hero">
      <div class="container">
        <nav aria-label="Breadcrumb" class="mb-3">
          <span class="eyebrow mb-0"><a class="hero-accent" href="/industries.html" data-testid="{d['slug']}-breadcrumb-link">Industries</a> / {d['name']}</span>
        </nav>
        <h1 class="mb-3">{d['h1']}</h1>
        <p class="hero-sub mb-4">{d['lead']}</p>
        <div class="d-flex flex-wrap gap-3">
          <a class="btn btn-accent btn-lg" href="{TRIAL}" data-testid="{d['slug']}-trial-btn">Start free trial</a>
          <a class="btn btn-outline-light btn-lg" href="/contact.html?product=esignature#demo" data-testid="{d['slug']}-demo-btn">Book a demo</a>
        </div>
      </div>
    </section>

""")
    # intro + image
    cls_first = ' class="lead"'
    cls_rest = ' class="text-muted"'
    paras = "\n".join('            <p%s>%s</p>' % (cls_first if i == 0 else cls_rest, p) for i, p in enumerate(d['intro']))
    out.write(f"""    <section class="section" data-testid="{d['slug']}-intro">
      <div class="container">
        <div class="row g-5 align-items-center">
          <div class="col-lg-6">
            <span class="eyebrow">{d['eyebrow']}</span>
            <h2 class="mb-3">{d['intro_head']}</h2>
{paras}
          </div>
          <div class="col-lg-6">
            <img class="img-fluid" style="border-radius: var(--sg-radius-lg); box-shadow: var(--sg-shadow-lg);"
                 src="{d['image']}" alt="{d['image_alt']}" width="940" height="650" loading="lazy">
          </div>
        </div>
      </div>
    </section>

""")
    # benefits
    cards = ""
    for i, (t, txt) in enumerate(d['benefits']):
        cards += f"""          <div class="col-md-6 col-lg-4 reveal">
            <div class="card card-hover h-100"><div class="card-body">
              <span class="icon-badge"><i class="bi bi-{d['icons'][i % len(d['icons'])]}" aria-hidden="true"></i></span>
              <h3 class="card-title h5">{t}</h3>
              <p class="text-muted mb-0">{txt}</p>
            </div></div>
          </div>
"""
    out.write(f"""    <section class="section section-alt" data-testid="{d['slug']}-benefits">
      <div class="container">
        <div class="section-head">
          <span class="eyebrow">Benefits</span>
          <h2 class="mb-3">{d['benefits_head']}</h2>
        </div>
        <div class="row g-4">
{cards}        </div>
      </div>
    </section>

""")
    # use cases
    if d.get('usecases'):
        items = "".join(f'            <li><i class="bi bi-check-circle-fill" aria-hidden="true"></i> {u}</li>\n' for u in d['usecases'])
        out.write(f"""    <section class="section" data-testid="{d['slug']}-usecases">
      <div class="container">
        <div class="section-head">
          <span class="eyebrow">Use cases</span>
          <h2 class="mb-0">{d['usecases_head']}</h2>
        </div>
        <div class="card"><div class="card-body">
          <ul class="check-list usecase-grid mb-0">
{items}          </ul>
        </div></div>
      </div>
    </section>

""")
    # summary
    sums = ""
    for icon, txt in d['summary']:
        sums += f"""          <div class="col-md-6 col-lg-4 reveal">
            <div class="d-flex gap-3">
              <span class="icon-badge mb-0"><i class="bi bi-{icon}" aria-hidden="true"></i></span>
              <p class="mb-0">{txt}</p>
            </div>
          </div>
"""
    out.write(f"""    <section class="section section-dark" data-testid="{d['slug']}-summary">
      <div class="container">
        <div class="section-head">
          <span class="eyebrow">At a glance</span>
          <h2 class="mb-0">Summary of Signulu benefits</h2>
        </div>
        <div class="row g-4">
{sums}        </div>
      </div>
    </section>

""")
    # closing + CTA
    out.write(f"""    <section class="section" data-testid="{d['slug']}-cta">
      <div class="container">
        <p class="lead mb-5" style="max-width: 60ch;">{d['closing']}</p>
        <div class="cta-band">
          <div class="row align-items-center g-4">
            <div class="col-lg-8">
              <h2 class="mb-2">Get up to 5 documents signed free, every month</h2>
              <p class="mb-0">Try Signulu eSignature for 14 days. No credit card required.</p>
            </div>
            <div class="col-lg-4 text-lg-end">
              <a class="btn btn-accent btn-lg mb-2" href="{TRIAL}" data-testid="{d['slug']}-cta-trial-btn">Start free trial</a>
              <a class="btn btn-outline-light btn-lg" href="/contact.html?product=esignature#demo" data-testid="{d['slug']}-cta-demo-btn">Book a demo</a>
            </div>
          </div>
        </div>
      </div>
    </section>
""")
    out.write(FOOT)
    return out.getvalue()


INDUSTRIES = [
 dict(slug="banking-and-financial-services", name="Banking &amp; Financial Services", icon="bank",
   title="eSignature for Banking &amp; Financial Services | SignuluOne",
   desc="Signulu eSignature for banks, lenders and asset managers: account opening, loan and mortgage applications, beneficiary changes and audit sign-offs, signed securely in minutes.",
   h1="Leveraging eSignature for the banking &amp; finance industry",
   lead="Boost your document workflow, cut manual tasks and keep every signature secure, compliant and auditable.",
   eyebrow="Why it matters",
   intro_head="Built for institutions that move on paperwork",
   intro=["The finance and banking industries deal with an overwhelming amount of documentation every single day, against a regulatory backdrop and customer expectations that demand your institution be more secure, agile and accessible than ever before.",
          "Whether you are a boutique finance firm, a mortgage lender, an asset management firm or in retail banking, Signulu is all about boosting your document management workflow and alleviating the manual tasks around it with a cloud-based eSignature solution."],
   image="https://images.pexels.com/photos/8815843/pexels-photo-8815843.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
   image_alt="Client signing a financial document on a tablet",
   benefits_head="How will Signulu benefit your financial institution?",
   icons=["send-check","clipboard-data","shield-lock","piggy-bank","people","graph-up"],
   benefits=[("Documents in your clients' hands faster",
              "Reduce the time it takes to get documents authorised by over 80%. Distribution and authorisation happen online, so documents come back in minutes rather than days."),
             ("Clear visibility to document status",
              "The transaction dashboard gives real-time visibility into who has received and signed each form — invaluable when multiple parties review the same set of documents."),
             ("Stay secure, trusted and compliant",
              "TLS 1.2 encryption, tamper-proof audit trail, data encryption and signer authentication, compliant with major eSignature laws including ESIGN and ITA-2000."),
             ("Reduce overhead and go greener",
              "A fully digital document platform cuts paper, toner and courier costs significantly — and saves a few trees along the way.")],
   usecases_head="Where finance teams use Signulu",
   usecases=["New account openings","Loan and mortgage applications","Transfer of assets","Change and approval of beneficiary forms","Change and approval of address forms","Retainer contracts","Maintenance and account change forms","Delegation of authority","Preparation and approval of credit reports","Audit sign-off","Disclosures","Subscription documentation","Redemption requests"],
   summary=[("person-check","Speed up in-person eSigning"),("cash-coin","Receive timely payments"),("diagram-3","Manage complex eSignature workflows"),("input-cursor-text","Avoid retyping the same information over and over"),("people","Collaborate seamlessly inside your department"),("cloud-check","Store documents in secure cloud storage")],
   closing="Do not let mountains of paperwork get in the way of productivity. If Signulu can help your banking or financial organisation achieve its digital transformation goals, talk to us — and try the full version free for 14 days."),

 dict(slug="real-estate", name="Real Estate", icon="house-door",
   title="eSignature for Real Estate — Leases, Offers &amp; Disclosures | SignuluOne",
   desc="Signulu eSignature for real estate: store, share and sign agreements, disclosures and property listing documents from anywhere, with tracking and audit-ready verification.",
   h1="eSignature in real estate",
   lead="Agreements, disclosures and listing documents signed online — no copies, no couriers, no second appointment.",
   eyebrow="Why it matters",
   intro_head="Cabinets of files belong in the past",
   intro=["Digital contracts and eSignatures have quickly become an essential part of today's world. Large cabinets filled with files used to be standard in every office; today those records live securely on the cloud.",
          "Adopting eSignatures makes an agency agile and far better aligned with the online expectations of today's buyers and tenants."],
   image="https://images.pexels.com/photos/1313534/pexels-photo-1313534.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
   image_alt="Modern apartment building with a glass facade",
   benefits_head="Benefits of using Signulu eSignature",
   icons=["cloud-check","pencil-square","truck","phone","bell","patch-check","files","shield-lock"],
   benefits=[("Easier storage and retrieval","Agreements, disclosures and legal or listing documents are stored and managed on the cloud, so staff can retrieve, access or share files anytime, from anywhere."),
             ("No more copies for every edit","Make changes electronically, save, and re-send to all parties to review and sign online instead of re-scanning lengthy contracts."),
             ("No courier waiting or cost","No expensive overnight or postal deliveries. Read, click, save — that is all."),
             ("Track every document and signer","Automated email notifications and an administrative dashboard show the status of all documents and signers at a glance."),
             ("Audit-ready verification","Every document eSigned with Signulu can be legally and securely verified under the scrutiny of any audit."),
             ("Templates for every transaction","Reusable templates make any residential or commercial transaction simpler than ever.")],
   usecases_head="Documents in a typical deal",
   usecases=["Property listing agreements","Purchase offers and counter-offers","Residential and commercial leases","Renewals and addenda","Mandatory disclosures","Rental applications","Property management agreements","Vendor and maintenance contracts"],
   summary=[("envelope-open","Invite clients to sign a legal form in seconds"),("phone","Get documents eSigned even on the go"),("shield-lock","Keep confidential data protected"),("people","Collaborate seamlessly on documents"),("file-earmark-richtext","Make your documents look professional"),("piggy-bank","Save on paper, toner, hardware and postage")],
   closing="Digital contracts and eSignature solutions from Signulu are one of the most secure ways to conduct property business. Try the free 14-day trial to see how quickly your next deal can close."),

 dict(slug="professional-services", name="Professional Services", icon="briefcase",
   title="eSignature for Professional Services &amp; Staffing | SignuluOne",
   desc="Signulu eSignature for recruiting, staffing and professional services teams: NDAs, candidate documentation, timesheets and PTO forms signed up to 80% faster.",
   h1="Utilising eSignature in professional services &amp; staffing",
   lead="Get candidate and client paperwork signed in minutes, and keep your consultants focused on billable work.",
   eyebrow="Why it matters",
   intro_head="Talent will not wait for paperwork",
   intro=["Identifying, screening and interviewing candidates has become harder, and when you cannot meet people in person it is harder still to have them sign the forms a visit to your office would normally cover.",
          "Recruiters deal with dozens of candidates who are asked to review and sign non-disclosure agreements, background checks and immigration forms — usually as soon as possible. eSignature makes those tasks secure, timely and efficient."],
   image="https://images.unsplash.com/photo-1698047682091-782b1e5c6536?crop=entropy&cs=srgb&fm=jpg&q=85&w=1200",
   image_alt="Recruiter shaking hands with a candidate across an office table",
   benefits_head="Benefits for recruiting and professional teams",
   icons=["person-plus","file-lock","clipboard-check","calendar-week","list-check","pencil-square"],
   benefits=[("New candidate documentation","Expedite the entire document process and get necessary forms signed up to 80% faster than paper-based routines — matching the digital habits of Millennial and Gen Z candidates."),
             ("Faster NDA approvals","Get candidates to sign NDAs well in advance, expediting recruiting workflows and keeping prospective employers happy."),
             ("Easily track document status","No more phone or email follow-ups: the user dashboard shows the real-time status of every pending document for employees, contractors and candidates."),
             ("Efficient PTO and timesheet management","Employees can fill out, sign and upload timesheets and PTO forms into your payroll or HR systems through open APIs."),
             ("Engagement letters and SOWs","Standard terms with partner review before the document reaches the client, signed the same day."),
             ("Change orders in writing","Scope changes authorised properly before work continues, with the approval recorded against the file.")],
   usecases_head="Documents professional teams send weekly",
   usecases=["Engagement letters","Statements of work","Mutual and one-way NDAs","Offer letters","Background check consent","Onboarding packs","Contractor agreements","Timesheets and PTO forms","Change orders","Renewal letters"],
   summary=[("speedometer2","Speed up recruitment processes"),("phone","Get vital documents signed on the go"),("check2-circle","Avoid the discrepancies of traditional paperwork"),("piggy-bank","Save on paper, toner, hardware and postage"),("bar-chart","Track document status from the admin dashboard"),("people","Keep consultants on revenue-generating work")],
   closing="Signulu streamlines the administrative work around interviewing, hiring and onboarding so your team can focus on candidate identification and pipeline development — saving time, increasing compliance and reducing errors."),

 dict(slug="manufacturing", name="Manufacturing", icon="gear-wide-connected",
   title="eSignature for Manufacturing — Contracts, SOWs &amp; POs | SignuluOne",
   desc="Signulu eSignature for manufacturers: align specs, contracts, SOWs, change orders and purchase orders faster, with reusable templates and secure cloud storage.",
   h1="eSignature for manufacturing",
   lead="Align specs, contracts and change orders in minutes so production starts sooner.",
   eyebrow="Why it matters",
   intro_head="Approvals should not take longer than production",
   intro=["Businesses report an 83% improvement in the time taken to gain approvals and an 86% saving in document costs simply by using an eSignature solution. Anything that saves time and money is a proven recipe for success.",
          "Before an order can even be fulfilled, a lot of energy goes into making sure specs, contracts and SOWs are aligned and agreed by both parties — often a longer process than the manufacturing itself. eSignature removes that bottleneck."],
   image="https://images.unsplash.com/photo-1717386255773-1e3037c81788?crop=entropy&cs=srgb&fm=jpg&q=85&w=1200",
   image_alt="Machinery on a modern manufacturing floor",
   benefits_head="Why manufacturers benefit from the eSignature revolution",
   icons=["hand-thumbs-up","exclamation-triangle","plug","cloud-check","files","truck"],
   benefits=[("Ease of getting approvals","Whether it is contracts, change orders or invoices, sign in, upload, hit send — and wait around 80% less than posting a hard copy for a wet signature."),
             ("Reduces errors","Terms and conditions are recorded digitally at the time of creation, removing the errors that creep in when physical agreements are re-scanned and re-keyed."),
             ("Legally acceptable and easy to integrate","eSigned agreements are legally acceptable, and the whole workflow integrates with your existing IT infrastructure. Documents stay traceable and verifiable for statutory audits."),
             ("Ease of storage","Templates and signed documents live on a secure cloud server rather than in a filing cabinet — with obvious savings on toner, paper, folders and cabinets."),
             ("Reusable purchase order templates","Generate reusable templates so repeat purchase orders and supplier forms go out in a couple of clicks."),
             ("Supplier collaboration at distance","Vendors, plants and customers sign from wherever they are, so multi-site approvals no longer stall the line.")],
   usecases_head="Documents on the plant floor and in the back office",
   usecases=["Supply agreements","Statements of work and specifications","Purchase orders","Change orders","Quality and inspection sign-offs","Non-disclosure agreements","Vendor onboarding forms","Invoices and delivery acceptance"],
   summary=[("phone","Manage documents on the go"),("lightning-charge","Get contracts signed faster"),("people","Collect multiple eSignatures in minutes"),("files","Process purchase orders faster with reusable templates"),("shield-check","Keep audit-ready records of every approval"),("piggy-bank","Cut printing, courier and storage costs")],
   closing="The digital world is the way forward in every domain — manufacturing included. Talk to us about mapping Signulu onto your approval chain, or start the free 14-day trial today."),

 dict(slug="healthcare", name="Healthcare", icon="heart-pulse",
   title="eSignature for Healthcare — Consent &amp; Intake Forms | SignuluOne",
   desc="Signulu eSignature for hospitals and clinics: patient intake, consent forms and visit reports signed securely, reducing admin burden and clerical errors.",
   h1="eSignatures are the future of healthcare",
   lead="For paperless, secure patient transactions — so staff spend more time with patients and less with paperwork.",
   eyebrow="Why it matters",
   intro_head="Less paperwork per patient",
   intro=["In healthcare nothing matters more than patient wellbeing while keeping overhead under control. Many hospitals identify the sheer volume of paperwork arriving with each new patient as the thing standing in the way of better service and cost management.",
          "Our objective is to greatly reduce the seemingly endless amount of paperwork needed to care for each patient, without loosening security or compliance."],
   image="https://images.unsplash.com/photo-1666886573531-48d2e3c2b684?crop=entropy&cs=srgb&fm=jpg&q=85&w=1200",
   image_alt="Clinician reviewing information with a patient on a tablet",
   benefits_head="How eSignature simplifies healthcare administration",
   icons=["clock-history","hospital","clipboard-pulse","shield-lock","check2-circle","people"],
   benefits=[("Records available anywhere","All records and documents can be accessed at any time and anywhere there is a data or internet connection."),
             ("Faster check-in","Speed up the check-in process, especially in emergency situations, so patients get attention sooner."),
             ("Lighter reporting burden","Patient visit and check-up reports become far less of an administrative burden for clinicians."),
             ("Improved compliance and security","Encrypted eSignatures with signer authentication improve both compliance posture and record security."),
             ("Fewer clerical errors","Digital fields and templates reduce clerical and data-entry mistakes in patient records."),
             ("More time for care","Staff are freed up to be with patients or collaborating with colleagues to provide an optimal level of care.")],
   usecases_head="Forms patients and staff sign",
   usecases=["Patient intake and registration","Consent for treatment","Financial responsibility forms","Privacy notices and acknowledgements","Referral and discharge paperwork","Vendor and supplier contracts","Staff onboarding and policy sign-offs"],
   summary=[("person-heart","Doctors get more time for direct patient care"),("calendar-check","Patients can sign documents before appointments"),("clipboard-data","Administrators focus on mission-critical tasks"),("piggy-bank","Decrease operational costs considerably"),("shield-lock","Keep patient data encrypted and access-controlled"),("phone","Collect signatures on any device, anywhere")],
   closing="If your hospital or practice would benefit from a digital signature and document management solution, book a demo or register for the free 14-day trial."),

 dict(slug="legal-services", name="Legal", icon="bank2",
   title="eSignature for Law Firms — Making the Business of Law Easier | SignuluOne",
   desc="Signulu eSignature for law firms: sign engagement letters, agreements and court-ready documents in minutes with full encryption, audit certificates and secure cloud storage.",
   h1="Making the business of law easier",
   lead="Agreements, contracts and forms signed in minutes instead of days — with an audit certificate on every one.",
   eyebrow="Why it matters",
   intro_head="Boxes of documents are optional now",
   intro=["Few industries rely on paper like the legal one, where file cabinets, overnight envelopes, toner cartridges and reams of paper are still common. That is why so many firms turn to eSignature to streamline document management and authorisation.",
          "No more printing documents, signing by hand, scanning, sending to the client, waiting for the return, then copying and filing again. That cycle creates process inefficiency, errors and avoidable cost."],
   image="https://images.pexels.com/photos/7841463/pexels-photo-7841463.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
   image_alt="Attorney signing legal documents at a desk in a law office",
   benefits_head="How Signulu benefits your law firm",
   icons=["shield-lock","patch-check","piggy-bank","exclamation-triangle","clock-history","cloud-check"],
   benefits=[("Security","Full encryption of signatures and data protects your clients' confidentiality, identity and privacy."),
             ("Legally binding","Signulu adheres to the guidelines of the eSign Act and UETA, and each signature carries a unique digital certificate that can be audited."),
             ("Cost efficient","Greatly reduce spend on paper, printer toner and expedited mail."),
             ("Reduce errors","Documents can be saved as templates and stored automatically after approval, leaving less room for clerical error."),
             ("Time savings","Shorten the creation, distribution and approval cycle — clients sign from a phone or computer in seconds."),
             ("Secure cloud storage","Signed documents are stored securely on encrypted cloud servers, retrievable whenever a matter is reopened.")],
   usecases_head="Documents firms send every day",
   usecases=["Engagement and retainer letters","Client agreements and addenda","Non-disclosure agreements","Settlement documents","Authority and consent forms","Vendor and lease contracts","Internal policy sign-offs"],
   summary=[("envelope-open","Invite clients to sign a legal form in seconds"),("phone","Get documents eSigned even on the go"),("shield-lock","Keep confidential data protected"),("people","Collaborate seamlessly on documents"),("file-earmark-richtext","Make your documents look professional"),("graph-up","Free paralegals for client development work")],
   closing="Spending less time on document administration means happier employees, happier clients and a better bottom line. Book a demo or register for the free 14-day trial."),

 dict(slug="information-technology", name="Information Technology", icon="cpu",
   title="eSignature for IT Operations — Policies, Assets &amp; Change Requests | SignuluOne",
   desc="Signulu eSignature for IT operations: digital asset tracking, policy acknowledgement, project authorisations and system change requests, all API-integrated.",
   h1="eSignature for IT operations",
   lead="Digitise asset tracking, policy acknowledgement and change authorisation so your team stays on the projects that matter.",
   eyebrow="Why it matters",
   intro_head="Admin should not slow the roadmap",
   intro=["With a growing dependency on robust digital experiences, the IT operations team is more vital than ever. Department heads cannot afford to lose time to inefficient administrative processes.",
          "Document management and eSignature is one of the first areas IT leaders look to improve — because every policy, sign-off and asset record is a small tax on delivery."],
   image="https://images.pexels.com/photos/1181354/pexels-photo-1181354.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
   image_alt="Engineer monitoring data servers with a tablet in a server room",
   benefits_head="How Signulu benefits IT operations",
   icons=["hdd-network","file-earmark-check","diagram-3","pencil-square","code-slash","shield-lock"],
   benefits=[("Digital asset tracking","Go digital for everything from employee disclosures to data collection, then push the data into your asset management systems through APIs."),
             ("Policy management","Employees review, acknowledge and approve IT policies from anywhere in the world in minutes rather than days."),
             ("Project coordination and authorisation","Improve cross-team communication and reduce errors by capturing proper authorisations before changing production requirements or environments."),
             ("System change requests","From bug fixes to new feature controls, embed authorised sign-offs into your IT project management systems."),
             ("API integration","Integrate existing applications and websites with our open APIs so you get Signulu without interrupting current workflows."),
             ("Security and retention","Encryption, role-based access and tamper-evident records keep every approval defensible at audit time.")],
   usecases_head="Where IT teams use Signulu",
   usecases=["Acceptable use and IT policy acknowledgement","Asset issue and return forms","Change request approvals","Access and privilege requests","Vendor and licence agreements","Project sign-offs and UAT acceptance","Security incident acknowledgements"],
   summary=[("send-check","Send multiple documents to be signed electronically"),("globe","Keep workflow uninterrupted from anywhere"),("files","Generate similar forms and host them in seconds"),("people","Collaborate seamlessly on documents"),("graph-up","Foster staff productivity"),("shield-check","Minimise risk of data loss")],
   closing="Signulu digitises and automates IT operations workflows across domains — purchasing, project sign-offs, asset tracking. Let Signulu handle signing and document automation while you deliver real business value."),
]

import os
os.chdir('/app/frontend/public')
for d in INDUSTRIES:
    open(f"{d['slug']}.html", 'w').write(page(d))
    print("wrote", d['slug'])
json.dump([{k: d[k] for k in ('slug','name','icon','lead')} for d in INDUSTRIES], open('/tmp/industries.json','w'))
