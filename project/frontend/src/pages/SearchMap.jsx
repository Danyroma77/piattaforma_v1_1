import { useEffect, useMemo, useState } from 'react';
import { Link } from 'react-router-dom';
import { MapContainer, TileLayer, Marker, Popup, useMapEvents } from 'react-leaflet';
import L from 'leaflet';
import './SearchMap.css';

const API = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8025';

const defaultIcon = L.icon({
  iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
});

function PositionMarker({ lat, lng }) {
  const map = useMapEvents({
    load() {
      map.flyTo([lat, lng], map.getZoom(), { animate: true });
    },
  });
  return null;
}

export default function SearchMap() {
  const [position, setPosition] = useState(null);
  const [err, setErr] = useState('');
  const [loading, setLoading] = useState(false);

  const [lat, setLat] = useState(45.0744);
  const [lng, setLng] = useState(7.6928);
  const [distance, setDistance] = useState(5);
  const [activityType, setActivityType] = useState('tutte');

  const [items, setItems] = useState([]);
  const [busy, setBusy] = useState(false);
  const [notice, setNotice] = useState('');

  const activityTypes = useMemo(() => {
    const set = new Set();
    items.forEach((i) => {
      if (i.activity_types && i.activity_types.length) {
        i.activity_types.forEach((t) => set.add(t));
      }
    });
    return Array.from(set).sort();
  }, [items]);

  useEffect(() => {
    if (!navigator.geolocation) {
      setErr('La geolocalizzazione non è supportata da questo browser.');
      return;
    }
    setLoading(true);
    setErr('');
    navigator.geolocation.getCurrentPosition(
      (pos) => {
        setLat(pos.coords.latitude);
        setLng(pos.coords.longitude);
        setPosition({ lat: pos.coords.latitude, lng: pos.coords.longitude });
        setLoading(false);
      },
      () => {
        setLoading(false);
        setErr('Impossibile ottenere la posizione. Controlla la tua posizione e riprova.');
      },
      { enableHighAccuracy: true, timeout: 10000, maximumAge: 60000 }
    );
  }, []);

  async function fetchNearby() {
    if (!position) return;
    setBusy(true);
    setNotice('');
    try {
      const r = await fetch(
        `${API}/api/public/activities-nearby?lat=${lat}&lon=${lng}&distance=${distance}`
      );
      const data = await r.json();
      if (!r.ok) throw new Error(data.detail || 'Richiesta non riuscita.');
      const list = data.items || [];
      const withDist = list.map((i) => {
        const d = i.distance_km != null ? +i.distance_km : null;
        return { ...i, distance_km: d };
      });
      withDist.sort((a, b) => (a.distance_km ?? 999) - (b.distance_km ?? 999));
      setItems(withDist);
    } catch (e) {
      setNotice(`${e.message} Controlla che i servizi siano avviati e riprova.`);
      setItems([]);
    } finally {
      setBusy(false);
    }
  }

  const resetFilters = () => {
    setActivityType('tutte');
    setDistance(5);
  };

  return (
    <div className="searchmap-page">
      <section className="page-intro">
        <div className="container">
          <span className="eyebrow"><i className="bi bi-map me-2" />Cerca su mappa</span>
          <h1>Trova le attività più vicine a te</h1>
          <p>
            La mappa agisce sulla tua geolocalizzazione attuale. Scegli una tipologia di
            attività e la distanza massima. I marker sono ordinati per distanza.
          </p>
        </div>
      </section>

      <section className="section-space">
        <div className="container">
          <div className="searchmap-grid">
            <div className="searchmap-map-wrapper">
              <MapContainer
                center={[lat, lng]}
                zoom={13}
                scrollWheelZoom={true}
                style={{ height: '100%', width: '100%', minHeight: 420 }}
              >
                <TileLayer
                  attribution='&copy; <a href="https://openstreetmap.org">OpenStreetMap</a> contributors'
                  url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                />
                {position && <PositionMarker lat={position.lat} lng={position.lng} />}
                {items.map((item) => (
                  <Marker key={item.id} position={[item.latitude, item.longitude]} icon={defaultIcon}>
                    <Popup>
                      <div style={{ minWidth: 200 }}>
                        <strong>{item.public_name || item.title}</strong>
                        <br />
                        <small>{item.category || item.activity_type || 'Attività'}</small>
                        <br />
                        <small>
                          <i className="bi bi-geo-alt me-1" />
                          {item.address || item.city || 'Indirizzo non disponibile'}
                        </small>
                        {item.distance_km != null && (
                          <small style={{ color: '#1E293B' }}>
                            <i className="bi bi-road me-1" />
                            {item.distance_km.toFixed(1)} km
                          </small>
                        )}
                        <br />
                        <small style={{ opacity: 0.85 }}>
                          {item.description || item.teaser || 'Nessuna descrizione disponibile.'}
                        </small>
                        <Link
                          to={
                            item.showcase_path || (item.showcase_path === 0 ? '/' : `/negozi/${item.id}`)
                          }
                          className="btn btn-sm btn-outline-primary mt-2"
                        >
                          Vetrina
                        </Link>
                      </div>
                    </Popup>
                  </Marker>
                ))}
              </MapContainer>
              <div className="map-legend">
                <i className="bi bi-crosshairs me-2" />
                Posizione attuale
                <i className="bi bi-geo-alt ms-3 me-2" />
                Attività trovate
              </div>
            </div>

            <div className="searchmap-side">
              <div className="card">
                <div className="card-body">
                  <div className="mb-3">
                    <label className="form-label">Posizione</label>
                    <div className="d-flex align-items-center gap-2">
                      {loading && <span className="badge bg-info text-bg-light">Ricerca posizione...</span>}
                      {err && <span className="badge bg-danger text-bg-light">{err}</span>}
                      {!loading && !err && position && (
                        <span className="badge bg-success text-bg-light">
                          <i className="bi bi-check-circle me-1" /> Posizione acquisita
                        </span>
                      )}
                    </div>
                    {!loading && !err && !position && (
                      <p className="text-muted small mb-0">
                        Abilita la geolocalizzazione per vedere le attività più vicine a te.
                      </p>
                    )}
                    {!loading && err && (
                      <p className="text-muted small mb-0">
                        <button
                          className="btn btn-sm btn-outline-primary"
                          onClick={() => window.location.reload()}
                        >
                          <i className="bi bi-arrow-clockwise me-1" /> Riprova
                        </button>
                      </p>
                    )}
                  </div>

                  <div className="mb-3">
                    <label className="form-label">Tipologia di attività</label>
                    <div className="list-group list-group-flush">
                      <div className="list-group-item d-flex justify-content-between align-items-center gap-2">
                        <span className="small">Tutte le attività</span>
                        <input
                          type="radio"
                          name="activityType"
                          value="tutte"
                          checked={activityType === 'tutte'}
                          onChange={() => setActivityType('tutte')}
                          className="form-check-input"
                        />
                      </div>
                      {activityTypes.map((t) => (
                        <div
                          key={t}
                          className={`list-group-item d-flex justify-content-between align-items-center gap-2 ${
                            activityType === t ? 'active' : ''
                          }`}
                        >
                          <span className="small">{t}</span>
                          <input
                            type="radio"
                            name="activityType"
                            value={t}
                            checked={activityType === t}
                            onChange={() => setActivityType(t)}
                            className="form-check-input"
                          />
                        </div>
                      ))}
                      {activityTypes.length === 0 && (
                        <div className="list-group-item text-muted small">
                          Nessuna tipologia disponibile.
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="mb-3">
                    <label className="form-label">Distanza massima</label>
                    <div className="d-flex gap-2 flex-wrap">
                      {([3, 5, 40, 100]).map((d) => (
                        <button
                          key={d}
                          type="button"
                          className={`btn btn-sm rounded-pill ${
                            distance === d ? 'btn-primary' : 'btn-outline-primary'
                          }`}
                          onClick={() => setDistance(d)}
                        >
                          {d} km
                        </button>
                      ))}
                    </div>
                  </div>

                  <div className="d-grid gap-2">
                    <button
                      className="btn btn-success"
                      onClick={fetchNearby}
                      disabled={!position || busy}
                    >
                      <i className="bi bi-map me-2" />
                      {busy ? 'Ricerca in corso...' : 'Trova attività vicine'}
                    </button>
                  </div>

                  {notice && <p className="alert alert-info mt-3">{notice}</p>}

                  {items.length > 0 && (
                    <div className="mt-4">
                      <h3 className="h5 mb-3">Risultati ({items.length})</h3>
                      <div className="list-group list-group-flush">
                        {items.map((item) => (
                          <div key={item.id} className="list-group-item">
                            <div className="d-flex w-100 overflow-hidden">
                              <h6 className="mb-0 me-2">{item.public_name || item.title}</h6>
                              <span className="badge bg-info text-bg-light small">
                                {item.distance_km?.toFixed(1) ?? '—'} km
                              </span>
                            </div>
                            <small className="text-muted">
                              {item.category || item.activity_type || 'Attività'}
                              {item.address ? ` · ${item.address}` : ''}
                              {item.city ? ` · ${item.city}` : ''}
                            </small>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}
                </div>
              </div>

              <div className="mt-3">
                <Link to="/" className="btn btn-outline-secondary w-100">
                  <i className="bi bi-arrow-left me-2" /> Torna alla home
                </Link>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}