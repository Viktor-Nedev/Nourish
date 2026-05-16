import from "@jac/runtime" { Link, jacIsLoggedIn }
import from "lucide-react" { Map, Package, Users, Calendar, Building2, Navigation, X, Filter, Locate }
import from ..data.mockData { get_mock_donations, get_mock_requests, get_mock_events }
import from ..components.Navbar { Navbar }

def:pub MapPage() -> JsxElement {
    has show_donations: bool = True;
    has show_requests: bool = True;
    has show_orgs: bool = True;
    has show_events: bool = True;
    has urgent_only: bool = False;
    has selected_marker: Any = None;
    has donations: list[Any] = [];
    has requests: list[Any] = [];
    has events: list[Any] = [];

    logged_in: bool = jacIsLoggedIn();

    async can with entry {
        donations = get_mock_donations();
        requests = get_mock_requests();
        events = get_mock_events();
    }

    def toggle_donations(e: MouseEvent) -> None { show_donations = not show_donations; }
    def toggle_requests(e: MouseEvent) -> None { show_requests = not show_requests; }
    def toggle_orgs(e: MouseEvent) -> None { show_orgs = not show_orgs; }
    def toggle_events(e: MouseEvent) -> None { show_events = not show_events; }
    def toggle_urgent(e: MouseEvent) -> None { urgent_only = not urgent_only; }
    def close_popup(e: MouseEvent) -> None { selected_marker = None; }

    def select_donation(d: Any) -> None { selected_marker = d; }
    def select_request(r: Any) -> None { selected_marker = r; }

    def urgency_color(u: str) -> str {
        if u == "critical" { return "#DC2626"; }
        if u == "high" { return "#EA580C"; }
        if u == "medium" { return "#F59E0B"; }
        return "#16A34A";
    }

    visible_donations: list[Any] = [d for d in donations if show_donations];
    visible_requests: list[Any] = [r for r in requests if show_requests and (not urgent_only or r["urgency"] == "critical" or r["urgency"] == "high")];

    return (
        <div className="min-h-screen bg-background flex flex-col">
            <Navbar role={"user"} />

            <div className="flex flex-1" style={{"height": "calc(100vh - 64px)"}}>
                <div className="w-80 bg-white border-r border-border flex flex-col overflow-hidden">
                    <div className="p-4 border-b border-border">
                        <h2 className="text-base font-bold text-foreground flex items-center gap-2">
                            <Map size={16} className="text-primary" />
                            {"Food Map"}
                        </h2>
                        <p className="text-xs text-muted-foreground mt-0.5">{"Live donations, requests & events"}</p>
                    </div>

                    <div className="p-4 border-b border-border">
                        <div className="text-xs font-bold text-muted-foreground uppercase tracking-wide mb-3">{"Filters"}</div>
                        <div className="flex flex-col gap-2">
                            <label className="flex items-center gap-2 cursor-pointer">
                                <input type="checkbox" checked={show_donations} onChange={toggle_donations} className="accent-amber-500" />
                                <span className="w-3 h-3 rounded-full bg-amber-400 flex-shrink-0" />
                                <span className="text-sm text-foreground">{"Donations (" + str(len(visible_donations)) + ")"}</span>
                            </label>
                            <label className="flex items-center gap-2 cursor-pointer">
                                <input type="checkbox" checked={show_requests} onChange={toggle_requests} className="accent-red-500" />
                                <span className="w-3 h-3 rounded-full bg-red-500 flex-shrink-0" />
                                <span className="text-sm text-foreground">{"Requests (" + str(len(visible_requests)) + ")"}</span>
                            </label>
                            <label className="flex items-center gap-2 cursor-pointer">
                                <input type="checkbox" checked={show_orgs} onChange={toggle_orgs} className="accent-green-500" />
                                <span className="w-3 h-3 rounded-full bg-green-500 flex-shrink-0" />
                                <span className="text-sm text-foreground">{"Organizations"}</span>
                            </label>
                            <label className="flex items-center gap-2 cursor-pointer">
                                <input type="checkbox" checked={show_events} onChange={toggle_events} className="accent-purple-500" />
                                <span className="w-3 h-3 rounded-full bg-purple-500 flex-shrink-0" />
                                <span className="text-sm text-foreground">{"Events"}</span>
                            </label>
                            <div className="border-t border-border pt-2 mt-1">
                                <label className="flex items-center gap-2 cursor-pointer">
                                    <input type="checkbox" checked={urgent_only} onChange={toggle_urgent} className="accent-red-500" />
                                    <span className="text-sm font-semibold text-red-600">{"Urgent only"}</span>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div className="flex-1 overflow-y-auto">
                        {show_donations and len(visible_donations) > 0 and
                            <div className="p-4">
                                <div className="text-xs font-bold text-muted-foreground uppercase tracking-wide mb-2">{"Available Donations"}</div>
                                <div className="flex flex-col gap-2">
                                    {[<div key={visible_donations[i]["id"]}
                                        className="p-3 rounded-lg border border-border hover:border-amber-300 hover:bg-amber-50 cursor-pointer transition-all"
                                        onClick={lambda(e: MouseEvent) -> None { select_donation(visible_donations[i]); }}
                                    >
                                        <div className="flex items-start justify-between gap-2">
                                            <div>
                                                <div className="text-sm font-semibold text-foreground">{visible_donations[i]["title"]}</div>
                                                <div className="text-xs text-muted-foreground mt-0.5">{visible_donations[i]["organization"]}</div>
                                                <div className="text-xs text-muted-foreground">{visible_donations[i]["quantity"] + " · " + visible_donations[i]["category"]}</div>
                                            </div>
                                            <span className="badge badge-amber text-xs flex-shrink-0">{"Avail."}</span>
                                        </div>
                                    </div>
                                    for i in range(len(visible_donations))]}
                                </div>
                            </div>
                        }

                        {show_requests and len(visible_requests) > 0 and
                            <div className="p-4 border-t border-border">
                                <div className="text-xs font-bold text-muted-foreground uppercase tracking-wide mb-2">{"Active Requests"}</div>
                                <div className="flex flex-col gap-2">
                                    {[<div key={visible_requests[i]["id"]}
                                        className="p-3 rounded-lg border border-border hover:border-red-300 hover:bg-red-50 cursor-pointer transition-all"
                                        onClick={lambda(e: MouseEvent) -> None { select_request(visible_requests[i]); }}
                                    >
                                        <div className="flex items-start justify-between gap-2">
                                            <div>
                                                <div className="text-sm font-semibold text-foreground">{visible_requests[i]["title"]}</div>
                                                <div className="text-xs text-muted-foreground mt-0.5">{visible_requests[i]["people_count"] + " people · " + visible_requests[i]["food_type"]}</div>
                                            </div>
                                            <span className={"urgency-" + visible_requests[i]["urgency"] + " text-xs flex-shrink-0"}>{visible_requests[i]["urgency"]}</span>
                                        </div>
                                    </div>
                                    for i in range(len(visible_requests))]}
                                </div>
                            </div>
                        }
                    </div>

                    {not logged_in and
                        <div className="p-4 border-t border-border bg-primary-light">
                            <p className="text-xs text-primary font-medium mb-2">{"Sign in to create requests or donate food"}</p>
                            <Link to="/auth" className="btn btn-primary btn-sm w-full">{"Sign in"}</Link>
                        </div>
                    }
                </div>

                <div className="flex-1 relative">
                    <div className="map-container h-full rounded-none border-0">
                        <div className="map-placeholder h-full relative">
                            <div className="absolute inset-0" style={{"background": "linear-gradient(135deg, #E8F4F8 0%, #D1E8F0 40%, #C8E0EC 100%)"}}>
                                <div className="absolute inset-0 opacity-20" style={{"backgroundImage": "repeating-linear-gradient(0deg, transparent, transparent 40px, rgba(0,0,0,0.05) 40px, rgba(0,0,0,0.05) 41px), repeating-linear-gradient(90deg, transparent, transparent 40px, rgba(0,0,0,0.05) 40px, rgba(0,0,0,0.05) 41px)"}} />
                            </div>

                            {show_donations and
                                <div>
                                    {[<div key={visible_donations[i]["id"]}
                                        className="absolute cursor-pointer transform -translate-x-1/2 -translate-y-1/2"
                                        style={{"left": str(20 + i * 15) + "%", "top": str(30 + i * 12) + "%"}}
                                        onClick={lambda(e: MouseEvent) -> None { select_donation(visible_donations[i]); }}
                                    >
                                        <div className="w-8 h-8 bg-amber-400 rounded-full border-2 border-white shadow-lg flex items-center justify-center hover:scale-110 transition-transform">
                                            <Package size={14} color="white" />
                                        </div>
                                        <div className="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-amber-400 rotate-45" />
                                    </div>
                                    for i in range(len(visible_donations))]}
                                </div>
                            }

                            {show_requests and
                                <div>
                                    {[<div key={visible_requests[i]["id"]}
                                        className="absolute cursor-pointer transform -translate-x-1/2 -translate-y-1/2"
                                        style={{"left": str(60 + i * 8) + "%", "top": str(25 + i * 15) + "%"}}
                                        onClick={lambda(e: MouseEvent) -> None { select_request(visible_requests[i]); }}
                                    >
                                        <div className={"w-8 h-8 rounded-full border-2 border-white shadow-lg flex items-center justify-center hover:scale-110 transition-transform " + ("bg-red-600" if visible_requests[i]["urgency"] == "critical" else "bg-red-400")}>
                                            <Users size={14} color="white" />
                                        </div>
                                        <div className={"absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 rotate-45 " + ("bg-red-600" if visible_requests[i]["urgency"] == "critical" else "bg-red-400")} />
                                    </div>
                                    for i in range(len(visible_requests))]}
                                </div>
                            }

                            <div className="absolute bottom-4 left-4 bg-white rounded-xl shadow-lg p-3 border border-border">
                                <div className="text-xs font-bold text-foreground mb-2">{"Legend"}</div>
                                <div className="flex flex-col gap-1.5">
                                    <div className="legend-item"><div className="legend-dot bg-amber-400" />{"Donations"}</div>
                                    <div className="legend-item"><div className="legend-dot bg-red-500" />{"Urgent requests"}</div>
                                    <div className="legend-item"><div className="legend-dot bg-green-500" />{"Organizations"}</div>
                                    <div className="legend-item"><div className="legend-dot bg-purple-500" />{"Events"}</div>
                                    <div className="legend-item"><div className="legend-dot bg-blue-500" />{"Your location"}</div>
                                </div>
                            </div>

                            <div className="absolute top-4 right-4 flex flex-col gap-2">
                                <button className="w-10 h-10 bg-white rounded-lg shadow-lg border border-border flex items-center justify-center hover:bg-muted">
                                    <Locate size={16} className="text-foreground" />
                                </button>
                            </div>

                            <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 text-center pointer-events-none">
                                <div className="bg-white/80 backdrop-blur-sm rounded-xl px-6 py-4 border border-border shadow-lg">
                                    <Map size={32} className="text-muted-foreground mx-auto mb-2" />
                                    <p className="text-sm font-semibold text-foreground">{"Interactive Map"}</p>
                                    <p className="text-xs text-muted-foreground">{"Mapbox integration ready"}</p>
                                    <p className="text-xs text-muted-foreground">{"Click markers in the sidebar"}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    {selected_marker is not None and
                        <div className="absolute top-4 left-4 w-72 bg-white rounded-xl shadow-xl border border-border p-4 z-10">
                            <div className="flex items-start justify-between mb-3">
                                <div className="flex-1 min-w-0">
                                    <div className="text-sm font-bold text-foreground">{selected_marker["title"]}</div>
                                    {selected_marker.get("organization") and
                                        <div className="text-xs text-muted-foreground mt-0.5">{selected_marker["organization"]}</div>
                                    }
                                </div>
                                <button className="btn btn-ghost p-1 ml-2" onClick={close_popup}>
                                    <X size={14} />
                                </button>
                            </div>
                            <p className="text-xs text-muted-foreground mb-3">{selected_marker["description"]}</p>
                            {selected_marker.get("pickup_address") and
                                <div className="text-xs text-foreground mb-3">
                                    <span className="font-semibold">{"Pickup: "}</span>
                                    {selected_marker["pickup_address"]}
                                </div>
                            }
                            {selected_marker.get("location_text") and
                                <div className="text-xs text-foreground mb-3">
                                    <span className="font-semibold">{"Location: "}</span>
                                    {selected_marker["location_text"]}
                                </div>
                            }
                            <div className="flex gap-2">
                                <Link to={"/donations/" + selected_marker["id"] if selected_marker.get("organization") else "/requests/" + selected_marker["id"]}
                                    className="btn btn-primary btn-sm flex-1 text-center">
                                    {"View Details"}
                                </Link>
                                <button className="btn btn-sm flex items-center gap-1">
                                    <Navigation size={12} />
                                    {"Navigate"}
                                </button>
                            </div>
                        </div>
                    }
                </div>
            </div>
        </div>
    );
}
