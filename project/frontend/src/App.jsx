import { useEffect, useState } from 'react';
import { Link, NavLink, Route, Routes, useLocation } from 'react-router-dom';
import SearchMap from './pages/SearchMap.jsx';

const API = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8025';

function Header() {
  const location = useLocation();
  useEffect(() => {
    const el = document.getElementById('siteNav');
    if (el?.classList.contains('show') && window.bootstrap) {
      window.bootstrap.Collapse.getOrCreateInstance(el).hide();
    }
    window.scrollTo({ top: 0, behavior: 'instant' });
  }, [location.pathname]);
  return (
    <header className="site-header">
      <nav className="navbar navbar-expand-lg">
        <div className="container">
          <Link className="navbar-brand" to="/">
            <span className="brand-symbol"><i className="bi bi-shop-window" /></span>
            <span style={{ color: 'var(--ink)' }}>Vetrine<span className="brand-dot">.</span></span>
          </Link>
          <button
            className="navbar-toggler"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#siteNav"
            aria-controls="siteNav"
            aria-expanded="false"
            aria-label="Apri navigazione"
          >
            <span className="navbar-toggler-icon" />
          </button>
          <div className="collapse navbar-collapse" id="siteNav">
            <div className="navbar-nav mx-auto">
              <NavLink className="nav-link" to="/come-funziona">
                Come funziona
              </NavLink>
              <NavLink className="nav-link" to="/negozi">
                Esplora i negozi
              </NavLink>
              <NavLink className="nav-link" to="/cerca-su-mappa">
                Cerca su mappa
              </NavLink>
              <NavLink className="nav-link" to="/blog">
                Blog e storie
              </NavLink>
              <NavLink className="nav-link" to="/contatti">
                Contatti
              </NavLink>
            </div>
            <div className="header-actions">
              <Link className="login-link" to="/accedi">
                Accedi
              </Link>
              <Link className="btn btn-primary rounded-pill px-4" to="/registrati">
                Registrati
              </Link>
            </div>
          </div>
        </div>
      </nav>
    </header>
  );
}

function Footer() {
  return (
    <footer className="site-footer">
      <div className="container footer-main">
        <div>
          <Link className="footer-brand" to="/">
            <span className="brand-symbol"><i className="bi bi-shop-window" /></span> Vetrine<span className="brand-dot">.</span>
          </Link>
          <p>Le attività del territorio, le persone, le storie da scoprire.</p>
        </div>
        <div className="footer-links">
          <Link to="/come-funziona">Come funziona</Link>
          <Link to="/negozi">Esplora i negozi</Link>
          <Link to="/cerca-su-mappa">Cerca su mappa</Link>
          <Link to="/blog">Blog</Link>
          <Link to="/contatti">Contatti</Link>
        </div>
      </div>
      <div className="container footer-bottom">
        <span>© {new Date().getFullYear()} Vetrine. Tutti i diritti riservati.</span>
        <span>Powered by <strong>EB Soluzioni</strong></span>
      </div>
    </footer>
  );
}

function PageIntro({ eyebrow, title, accent, description }) {
  return (
    <section className="page-intro">
      <div className="container">
        <span className="eyebrow">{eyebrow}</span>
        <h1>{title} <span>{accent}</span></h1>
        {description && <p>{description}</p>}
      </div>
    </section>
  );
}

function Home() {
  return (
    <>
      <section className="home-hero">
        <div className="container home-hero-grid">
          <div className="hero-content">
            <span className="eyebrow"><span className="eyebrow-dot" /> Il territorio, tutto da scoprire</span>
            <h1>Il tuo prossimo<br />posto preferito<br /><span>è più vicino.</span></h1>
            <p>Scopri negozi, servizi e iniziative locali. Segui le attività che ti piacciono e resta aggiornato sulle novità del tuo territorio.</p>
            <div className="hero-actions">
              <Link className="btn btn-primary btn-lg rounded-pill px-4" to="/negozi">
                Esplora le attività <i className="bi bi-arrow-up-right ms-2" />
              </Link>
              <Link className="btn btn-outline-dark btn-lg rounded-pill px-4" to="/come-funziona">
                Scopri come funziona
              </Link>
            </div>
            <div className="hero-footnote">
              <i className="bi bi-check-circle-fill" /> Vetrine pubbliche consultabili senza registrazione
            </div>
          </div>
          <div className="hero-illustration" aria-label="Anteprima illustrativa delle vetrine">
            <div className="decor-circle circle-one" />
            <div className="decor-circle circle-two" />
            <div className="discovery-card">
              <div className="discovery-top"><span>DA SCOPRIRE VICINO A TE</span><i className="bi bi-sliders" /></div>
              <div className="discovery-place">
                <div className="place-thumb thumb-green"><i className="bi bi-basket2" /></div>
                <div><b>La Bottega</b><small>Alimentari · Centro</small></div>
                <i className="bi bi-heart place-heart" />
              </div>
              <div className="discovery-place">
                <div className="place-thumb thumb-rose"><i className="bi bi-flower1" /></div>
                <div><b>Studio Benessere</b><small>Servizi · Quartiere</small></div>
                <i className="bi bi-heart place-heart" />
              </div>
              <div className="discovery-feature">
                <span>INIZIATIVA DELLA SETTIMANA</span>
                <h3>Piccole novità,<br />grandi scoperte.</h3>
                <p>Le storie dei negozi che rendono vivo il quartiere.</p>
                <i className="bi bi-arrow-up-right feature-arrow" />
              </div>
              <div className="discovery-bottom">
                <span><i className="bi bi-compass-fill" /> Esplora</span>
                <span><i className="bi bi-heart" /> Preferiti</span>
                <span><i className="bi bi-person" /> Profilo</span>
              </div>
            </div>
            <div className="floating-pill"><i className="bi bi-geo-alt-fill" /> Vicino a te</div>
            <div className="floating-sticker"><i className="bi bi-stars" /></div>
          </div>
        </div>
      </section>
      <section className="home-benefits section-space">
        <div className="container">
          <div className="section-heading">
            <span className="eyebrow">Un'esperienza semplice</span>
            <h2>Un modo nuovo di vivere<br /><span>le attività locali.</span></h2>
            <p>Un punto di incontro digitale per scoprire realtà vicine, seguire le loro iniziative e creare nuove abitudini.</p>
          </div>
          <div className="row g-4 mt-3">
            <div className="col-md-4">
              <div className="benefit-card">
                <span className="benefit-icon"><i className="bi bi-compass" /></span>
                <h3>Esplora</h3>
                <p>Trova negozi e servizi, conosci le loro storie e scopri cosa offre il territorio.</p>
                <Link to="/negozi">Scopri le attività <i className="bi bi-arrow-right" /></Link>
              </div>
            </div>
            <div className="col-md-4">
              <div className="benefit-card">
                <span className="benefit-icon"><i className="bi bi-megaphone" /></span>
                <h3>Resta aggiornato</h3>
                <p>Consulta novità, iniziative e comunicazioni delle attività che partecipano.</p>
                <Link to="/blog">Leggi le storie <i className="bi bi-arrow-right" /></Link>
              </div>
            </div>
            <div className="col-md-4">
              <div className="benefit-card">
                <span className="benefit-icon"><i className="bi bi-heart" /></span>
                <h3>Partecipa</h3>
                <p>Con un account potrai accedere alle funzionalità riservate agli utenti registrati.</p>
                <Link to="/registrati">Crea un account <i className="bi bi-arrow-right" /></Link>
              </div>
            </div>
          </div>
        </div>
      </section>
      <section className="home-business section-space">
        <div className="container business-banner">
          <div>
            <span className="eyebrow">Sei un'attività locale?</span>
            <h2>Fai conoscere il tuo mondo.</h2>
            <p>Presenta la tua attività</p>
          </div>
        </div>
      </section>
    </>
  );
}

function HowItWorks() {
  return (
    <>
      <PageIntro
        eyebrow="Come funziona"
        title="Un'unica piattaforma,"
        accent="due prospettive."
        description="Un'esperienza pensata per chi vuole scoprire le attività del territorio e per chi desidera far conoscere il proprio negozio."
      />
      <section className="section-space">
        <div className="container">
          <div className="row g-4">
            <div className="col-lg-6">
              <article className="audience-card">
                <div className="audience-icon"><i className="bi bi-person-heart" /></div>
                <span className="eyebrow">Per gli utenti</span>
                <h2>Scopri i luoghi<br />che fanno per te.</h2>
                <p>Puoi consultare le vetrine pubbliche senza registrarti. Creando un account avrai accesso alle funzioni riservate e potrai gestire la tua esperienza personale.</p>
                <ul>
                  <li>Esplora negozi, servizi e sedi.</li>
                  <li>Consulta offerte e iniziative pubblicate.</li>
                  <li>Accedi ai programmi fidelity disponibili.</li>
                  <li>Ricevi comunicazioni secondo le preferenze previste.</li>
                </ul>
                <Link className="btn btn-primary rounded-pill px-4" to="/registrati">
                  Registrati come utente
                </Link>
              </article>
            </div>
            <div className="col-lg-6">
              <article className="audience-card audience-dark">
                <div className="audience-icon"><i className="bi bi-shop-window" /></div>
                <span className="eyebrow">Per negozianti e attività</span>
                <h2>Il tuo negozio,<br />raccontato meglio.</h2>
                <p>Il referente autorizzato avrà uno spazio per gestire la presenza digitale dell'attività e le sedi collegate.</p>
                <ul>
                  <li>Presenta la tua attività e i tuoi servizi.</li>
                  <li>Gestisci più sedi da un unico profilo autorizzato.</li>
                  <li>Pubblica offerte, campagne e aggiornamenti.</li>
                  <li>Gestisci le operazioni fidelity abilitate.</li>
                </ul>
                <Link className="btn btn-light rounded-pill px-4" to="/registrati?profilo=negoziante">
                  Registra un'attività
                </Link>
              </article>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}

function Businesses() {
  const [items, setItems] = useState([]);
  const [query, setQuery] = useState('');

  useEffect(() => {
    fetch(`${API}/api/public/featured-businesses`)
      .then((r) => (r.ok ? r.json() : Promise.reject()))
      .then((d) => setItems(d.items || []))
      .catch(() => {});
  }, []);

  const demo = [
    { id: 'a', public_name: 'La Bottega del Quartiere', category: 'Alimentari', city: 'Centro', description: 'Prodotti scelti e attenzione alle persone.' },
  ];

  const all = items.length ? items : demo;
  const filtered = all.filter(
    (x) =>
      `${x.public_name} ${x.category || ''} ${x.city || ''}`.toLowerCase().includes(query.toLowerCase())
  );

  return (
    <>
      <PageIntro
        eyebrow="Esplora il territorio"
        title="Le attività da"
        accent="scoprire."
        description="Cerca una realtà, lasciati ispirare e scopri le attività che partecipano alla piattaforma."
      />
      <section className="section-space">
        <div className="container">
          <div className="directory-toolbar">
            <div className="d-flex flex-wrap align-items-center gap-2">
              <h2>Vetrine locali</h2>
              <p>Una selezione dimostrativa di attività.</p>
            </div>
            <div className="search-box">
              <i className="bi bi-search" />
              <input
                aria-label="Cerca attività"
                placeholder="Cerca nome, categoria o zona"
                value={query}
                onChange={(e) => setQuery(e.target.value)}
              />
            </div>
          </div>
          <div className="row g-4 mt-2">
            {filtered.map((b, i) => (
              <div className="col-md-6 col-lg-4" key={b.id}>
                <article className="directory-card h-100">
                  <div className={`directory-art art-${i % 3}`}>
                    <span>{b.category || 'Attività locale'}</span>
                    <i className={i % 3 === 0 ? 'bi bi-basket2' : i % 3 === 1 ? 'bi bi-flower1' : 'bi bi-stars'} />
                  </div>
                  <div className="card-copy">
                    <small><i className="bi bi-geo-alt" /> {b.city || 'Territorio'}</small>
                    <h3>{b.public_name}</h3>
                    <p>{b.description || 'Scopri la vetrina di questa attività.'}</p>
                    <Link to="/accedi">Accedi per continuare <i className="bi bi-arrow-up-right" /></Link>
                  </div>
                </article>
              </div>
            ))}
          </div>
          {filtered.length === 0 && <div className="empty-state">Nessuna attività corrisponde alla ricerca. Prova un altro termine.</div>}
          <p className="demo-note mt-4">
            <i className="bi bi-info-circle me-2" />Le attività mostrate sono esempi dimostrativi e non rappresentano esercenti reali.
          </p>
        </div>
      </section>
    </>
  );
}

function Blog() {
  const [posts, setPosts] = useState([]);
  const [query, setQuery] = useState('');

  useEffect(() => {
    fetch(`${API}/api/public/blog`)
      .then((r) => (r.ok ? r.json() : Promise.reject()))
      .then((d) => setPosts(d.items || []))
      .catch(() => {});
  }, []);

  const demo = [
    { id: '1', title: 'Una vetrina digitale', excerpt: 'Raccontare la propria attività, condividere novità e creare relazioni con le persone del territorio.', body: 'Contenuto dimostrativo di prova.', category: 'Vetrina', published_at: new Date().toISOString() },
  ];

  const all = posts.length ? posts : demo;
  const filtered = all.filter(
    (p) =>
      `${p.title} ${p.excerpt} ${p.category || ''}`.toLowerCase().includes(query.toLowerCase())
  );

  return (
    <>
      <PageIntro
        eyebrow="Blog"
        title="Le storie del"
        accent="territorio."
        description="Comunicazioni, racconti e iniziative selezionati dalla redazione della piattaforma."
      />
      <section className="section-space">
        <div className="container">
          <div className="blog-feature">
            <div className="blog-feature-art"><i className="bi bi-journal-richtext" /></div>
            <div>
              <span className="eyebrow">Dalla redazione</span>
              <h2>Ogni attività ha una storia da raccontare.</h2>
              <p>Uno spazio editoriale per condividere novità della piattaforma, iniziative e storie delle attività aderenti. Gli articoli saranno pubblicati dagli amministratori.</p>
            </div>
          </div>
          <div className="row g-4 mt-4">
            {filtered.map((p, i) => (
              <article className="blog-card h-100" key={p.id || p.slug}>
                <div className={`blog-card-art art-${i % 3}`}>
                  <i className={i % 3 === 0 ? 'bi bi-journal-richtext' : i % 3 === 1 ? 'bi bi-geo-alt' : 'bi bi-chat-heart'} />
                  <span>{p.category || 'Notizie'}</span>
                </div>
                <div className="card-copy">
                  <small>{p.published_at ? new Date(p.published_at).toLocaleDateString('it-IT') : 'DAL BLOG'}</small>
                  <h3>{p.title}</h3>
                  <p>{p.excerpt || p.body || 'Leggi le ultime notizie e storie della community.'}</p>
                  <span className="coming-soon">Articolo dimostrativo</span>
                </div>
              </article>
            ))}
          </div>
        </div>
      </section>
    </>
  );
}

function Contact() {
  const [form, setForm] = useState({ name: '', email: '', profile: 'utente', message: '', privacy_consent: false });
  const [notice, setNotice] = useState('');
  const [busy, setBusy] = useState(false);

  const change = (e) => setForm((p) => ({ ...p, [e.target.name]: e.target.type === 'checkbox' ? e.target.checked : e.target.value }));

  async function submit(e) {
    e.preventDefault();
    setBusy(true);
    setNotice('');
    try {
      const r = await fetch(`${API}/api/public/contact`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(form),
      });
      const data = await r.json();
      if (!r.ok) throw new Error(data.detail || 'Invio non riuscito.');
      setNotice('Richiesta ricevuta. Grazie per averci scritto!');
      setForm({ name: '', email: '', profile: 'utente', message: '', privacy_consent: false });
    } catch (err) {
      setNotice(`${err.message} Controlla che i servizi siano avviati e riprova.`);
    } finally {
      setBusy(false);
    }
  }

  return (
    <>
      <PageIntro
        eyebrow="Contatti"
        title="Siamo qui per"
        accent="ascoltarti."
        description="Hai una domanda, vuoi partecipare o rappresenti un'attività interessata? Scrivici."
      />
      <section className="section-space">
        <div className="container contact-layout">
          <div className="contact-side">
            <h2>Parliamone.</h2>
            <p>Raccontaci cosa ti interessa e ti aiuteremo a capire come usare la piattaforma.</p>
            <div className="contact-side-item">
              <i className="bi bi-person-heart" />
              <div><b>Sei un utente?</b><span>Chiedici come iniziare e scoprire le attività.</span></div>
            </div>
            <div className="contact-side-item">
              <i className="bi bi-shop" />
              <div><b>Hai un'attività?</b><span>Scrivici per conoscere gli strumenti dedicati ai negozianti.</span></div>
            </div>
          </div>
          <form className="contact-form" onSubmit={submit}>
            <div className="row g-3">
              <div className="col-md-6">
                <label className="form-label">Nome e cognome</label>
                <input className="form-control" name="name" value={form.name} onChange={change} minLength={2} required />
              </div>
              <div className="col-md-6">
                <label className="form-label">Email</label>
                <input className="form-control" type="email" name="email" value={form.email} onChange={change} required />
              </div>
              <div className="col-12">
                <label className="form-label">Ti interessa come...</label>
                <select className="form-select" name="profile" value={form.profile} onChange={change}>
                  <option value="utente">Utente</option>
                  <option value="negoziante">Negoziante o attività</option>
                  <option value="altro">Altro</option>
                </select>
              </div>
              <div className="col-12">
                <label className="form-label">Messaggio</label>
                <textarea className="form-control" name="message" rows={5} minLength={10} maxLength={4000} value={form.message} onChange={change} required />
              </div>
              <div className="col-12">
                <div className="form-check">
                  <input className="form-check-input" type="checkbox" id="privacyConsent" name="privacy_consent" checked={form.privacy_consent} onChange={change} required />
                  <label className="form-check-label small" htmlFor="privacyConsent">
                    Confermo di aver letto l'informativa sulla privacy.
                  </label>
                </div>
              </div>
              <div className="col-12">
                <button className="btn btn-primary w-100" type="submit" disabled={busy}>
                  {busy ? 'Invio in corso...' : 'Invia messaggio'}
                </button>
              </div>
            </div>
          </form>
        </div>
      </section>
    </>
  );
}

function AuthLayout({ mode }) {
  const register = mode === 'register';
  const [showPassword, setShowPassword] = useState(false);
  const [notice, setNotice] = useState('');

  function submit(e) {
    e.preventDefault();
    setNotice(register ? 'La registrazione non è ancora collegata al backend.' : 'L’autenticazione non è ancora collegata al backend.');
  }

  return (
    <section className="auth-page">
      <div className="container auth-grid">
        <div className="auth-promo">
          <Link to="/" className="auth-logo">
            <span className="brand-symbol"><i className="bi bi-shop-window" /></span> Vetrine<span className="brand-dot">.</span>
          </Link>
          <span className="eyebrow">{register ? 'Benvenuto nella community' : 'Felici di rivederti'}</span>
          <h1>{register ? 'Crea il tuo spazio.' : 'Bentornato.'}<br /><span>{register ? 'Scopri nuove possibilità.' : 'Riprendi da dove eri.'}</span></h1>
          <p>{register ? 'Scegli come vuoi partecipare: come utente o come referente di un’attività.' : 'Accedi al tuo account per continuare a utilizzare le funzionalità della piattaforma.'}</p>
          <div className="auth-promo-points">
            <span><i className="bi bi-check-circle" /> Un unico account</span>
            <span><i className="bi bi-check-circle" /> Esperienza semplice</span>
            <span><i className="bi bi-check-circle" /> Attività e iniziative in un unico posto</span>
          </div>
          <div className="auth-shapes">
            <i className="bi bi-shop-window" />
            <i className="bi bi-stars" />
            <i className="bi bi-heart" />
          </div>
        </div>
        <div className="auth-panel">
          <div className="auth-panel-inner">
            <div className="auth-panel-heading">
              <span className="eyebrow">{register ? 'Registrazione' : 'Area personale'}</span>
              <h2>{register ? 'Crea un account' : 'Accedi al tuo account'}</h2>
              <p>{register ? 'Bastano pochi dati per iniziare.' : 'Inserisci le credenziali per proseguire.'}</p>
            </div>
            {register && (
              <div className="profile-toggle" role="group" aria-label="Tipo di account">
                <button type="button" className={mode === 'register' ? 'selected' : ''} onClick={() => setProfile('utente')}>
                  <i className="bi bi-person" /> Sono un utente
                </button>
                <button type="button" className={mode === 'register' ? 'selected' : ''} onClick={() => setProfile('negoziante')}>
                  <i className="bi bi-shop" /> Sono un negoziante
                </button>
              </div>
            )}
            <form onSubmit={submit} className="auth-form">
              {register && (
                <div className="mb-3">
                  <label className="form-label">{profile === 'negoziante' ? 'Nome dell’attività' : 'Nome e cognome'}</label>
                  <input className="form-control" name="name" value={form.name} onChange={change} minLength={2} required />
                </div>
              )}
              <div className="mb-3">
                <label className="form-label">Email</label>
                <input className="form-control" type="email" name="email" value={form.email} onChange={change} required />
              </div>
              <div className="mb-3">
                <label className="form-label">Password</label>
                <div className="input-group">
                  <input
                    className="form-control"
                    type={showPassword ? 'text' : 'password'}
                    name="password"
                    value={form.password}
                    onChange={change}
                    required
                  />
                  <button type="button" className="btn btn-outline-secondary" onClick={() => setShowPassword(!showPassword)}>
                    <i className={showPassword ? 'bi bi-eye-slash' : 'bi bi-eye'} />
                  </button>
                </div>
              </div>
              {register && (
                <div className="mb-3">
                  <label className="form-label">Conferma password</label>
                  <input className="form-control" type="password" name="confirm_password" value={form.confirm_password} onChange={change} required />
                </div>
              )}
              <div className="mb-3">
                <div className="form-check">
                  <input className="form-check-input" type="checkbox" name="terms" id="terms" checked={form.terms} onChange={change} required />
                  <label className="form-check-label small" htmlFor="terms">
                    Accetto i termini e le condizioni.
                  </label>
                </div>
              </div>
              <button className="btn btn-primary w-100" type="submit" disabled={busy}>
                {busy ? 'Caricamento...' : register ? 'Registrati' : 'Accedi'}
              </button>
              {notice && <div className="alert alert-info mt-2">{notice}</div>}
            </form>
          </div>
        </div>
      </div>
    </section>
  );
}

export default function App() {
  return (
    <>
      <Header />
      <main>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/come-funziona" element={<HowItWorks />} />
          <Route path="/negozi" element={<Businesses />} />
          <Route path="/blog" element={<Blog />} />
          <Route path="/contatti" element={<Contact />} />
          <Route path="/cerca-su-mappa" element={<SearchMap />} />
          <Route path="/accedi" element={<AuthLayout mode="login" />} />
          <Route path="/registrati" element={<AuthLayout mode="register" />} />
          <Route path="*" element={<PageIntro eyebrow="Pagina non trovata" title="Questa pagina" accent="non esiste." description="Controlla l'indirizzo oppure torna alla home." />} />
        </Routes>
      </main>
      <Footer />
    </>
  );
}