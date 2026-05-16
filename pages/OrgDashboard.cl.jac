import from "@jac/runtime" { Link, Navigate, jacIsLoggedIn }
import from "lucide-react" {
    LayoutDashboard, Package, Users, Calendar, Brain, Bell,
    TrendingUp, AlertTriangle, Clock, CheckCircle, ArrowRight,
    Zap, Heart, MapPin, Plus
}
import from ..components.Navbar { Navbar }
import from ..components.Sidebar { Sidebar }
import from ..data.mockData { get_mock_donations, get_mock_requests, get_mock_org_stats, get_mock_ai_insights }

def:pub OrgDashboard() -> JsxElement {
    has stats: Any = None;
    has donations: list[Any] = [];
    has requests: list[Any] = [];
    has insights: list[Any] = [];

    if not jacIsLoggedIn() {
        return <Navigate to="/auth" replace={True} />;
    }

    async can with entry {
        stats = get_mock_org_stats();
        donations = get_mock_donations();
        requests = get_mock_requests();
        insights = get_mock_ai_insights();
    }

    meals: int = stats.meals_saved if stats is not None else 2847;
    people: int = stats.people_helped if stats is not None else 1203;
    active_don: int = stats.donations_active if stats is not None else 12;
    fulfilled: int = stats.requests_fulfilled if stats is not None else 89;
    food_kg: int = stats.food_rescued_kg if stats is not None else 4200;
    avg_resp: str = stats.avg_response_time if stats is not None else "2.4 hrs";

    urgent_requests: list[Any] = [r for r in requests if r["urgency"] == "critical" or r["urgency"] == "high"];
    expiring: list[Any] = [d for d in donations if d["status"] == "expiring_soon"];

    return (
        <div className="min-h-screen bg-background">
            <Navbar role={"org"} />
            <div className="dashboard-layout">
                <Sidebar role={"org"} />
                <div className="dashboard-content">
                    <div className="page-header flex items-center justify-between">
                        <div>
                            <h1 className="page-title">{"Organization Dashboard"}</h1>
                            <p className="page-subtitle">{"Welcome back. Here's your impact overview."}</p>
                        </div>
                        <div className="flex gap-2">
                            <Link to="/donations/new" className="btn btn-primary flex items-center gap-2">
                                <Plus size={16} />
                                {"Add Donation"}
                            </Link>
                            <Link to="/events/new" className="btn flex items-center gap-2">
                                <Calendar size={16} />
                                {"Create Event"}
                            </Link>
                        </div>
                    </div>

                    {len(urgent_requests) > 0 and
                        <div className="alert-banner alert-banner-red mb-6">
                            <AlertTriangle size={18} className="flex-shrink-0 mt-0.5" />
                            <div>
                                <div className="font-semibold text-sm">{str(len(urgent_requests)) + " urgent requests need attention"}</div>
                                <div className="text-xs mt-0.5">{"Critical food needs in your area. Act now to make an impact."}</div>
                            </div>
                            <Link to="/requests" className="btn btn-sm bg-red-700 text-white border-red-700 ml-auto flex-shrink-0">
                                {"View Requests"}
                            </Link>
                        </div>
                    }

                    <div className="grid grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4 mb-6">
                        <div className="stat-card">
                            <div className="flex items-center gap-2 mb-2">
                                <Heart size={16} className="text-primary" />
                                <span className="stat-label">{"Meals Saved"}</span>
                            </div>
                            <div className="stat-value text-primary">{str(meals)}</div>
                            <div className="stat-change stat-change-up">{"↑ 12% this month"}</div>
                        </div>
                        <div className="stat-card">
                            <div className="flex items-center gap-2 mb-2">
                                <Users size={16} className="text-blue-600" />
                                <span className="stat-label">{"People Helped"}</span>
                            </div>
                            <div className="stat-value">{str(people)}</div>
                            <div className="stat-change stat-change-up">{"↑ 8% this month"}</div>
                        </div>
                        <div className="stat-card">
                            <div className="flex items-center gap-2 mb-2">
                                <Package size={16} className="text-amber-600" />
                                <span className="stat-label">{"Active Donations"}</span>
                            </div>
                            <div className="stat-value">{str(active_don)}</div>
                            <div className="stat-change">{"3 expiring soon"}</div>
                        </div>
                        <div className="stat-card">
                            <div className="flex items-center gap-2 mb-2">
                                <CheckCircle size={16} className="text-green-600" />
                                <span className="stat-label">{"Requests Fulfilled"}</span>
                            </div>
                            <div className="stat-value text-green-600">{str(fulfilled)}</div>
                            <div className="stat-change stat-change-up">{"↑ 5 this week"}</div>
                        </div>
                        <div className="stat-card">
                            <div className="flex items-center gap-2 mb-2">
                                <TrendingUp size={16} className="text-purple-600" />
                                <span className="stat-label">{"Food Rescued"}</span>
                            </div>
                            <div className="stat-value">{str(food_kg) + "kg"}</div>
                            <div className="stat-change">{"This month"}</div>
                        </div>
                        <div className="stat-card">
                            <div className="flex items-center gap-2 mb-2">
                                <Clock size={16} className="text-muted-foreground" />
                                <span className="stat-label">{"Avg Response"}</span>
                            </div>
                            <div className="stat-value text-sm font-bold">{avg_resp}</div>
                            <div className="stat-change stat-change-up">{"↓ 15min faster"}</div>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
                        <div className="lg:col-span-2">
                            <div className="card">
                                <div className="p-5 border-b border-border flex items-center justify-between">
                                    <h3 className="section-title mb-0">
                                        <Package size={16} className="text-amber-500" />
                                        {"Active Donations"}
                                    </h3>
                                    <Link to="/donations/feed" className="text-xs text-primary font-semibold hover:underline">{"View all"}</Link>
                                </div>
                                <div className="divide-y divide-border">
                                    {[<div key={donations[i]["id"]} className="p-4 flex items-center justify-between hover:bg-muted/50">
                                        <div className="flex items-center gap-3">
                                            <div className="w-10 h-10 bg-amber-50 rounded-lg flex items-center justify-center flex-shrink-0">
                                                <Package size={18} className="text-amber-500" />
                                            </div>
                                            <div>
                                                <div className="text-sm font-semibold text-foreground">{donations[i]["title"]}</div>
                                                <div className="text-xs text-muted-foreground">{donations[i]["quantity"] + " · Expires " + donations[i]["expiry_date"]}</div>
                                            </div>
                                        </div>
                                        <div className="flex items-center gap-2">
                                            <span className={"badge " + ("badge-red" if donations[i]["status"] == "expiring_soon" else "badge-green")}>
                                                {donations[i]["status"]}
                                            </span>
                                            <Link to={"/donations/" + donations[i]["id"]} className="btn btn-ghost btn-sm">
                                                <ArrowRight size={14} />
                                            </Link>
                                        </div>
                                    </div>
                                    for i in range(min(4, len(donations)))]}
                                </div>
                            </div>
                        </div>

                        <div>
                            <div className="card mb-4">
                                <div className="p-5 border-b border-border">
                                    <h3 className="section-title mb-0">
                                        <Brain size={16} className="text-purple-500" />
                                        {"AI Recommendations"}
                                    </h3>
                                </div>
                                <div className="p-4 flex flex-col gap-3">
                                    {[<div key={str(i)} className={"p-3 rounded-lg border " + ("border-red-200 bg-red-50" if insights[i]["priority"] == "critical" else ("border-amber-200 bg-amber-50" if insights[i]["priority"] == "high" else "border-border bg-muted/30"))}>
                                        <div className="text-xs font-bold text-foreground mb-1">{insights[i]["title"]}</div>
                                        <div className="text-xs text-muted-foreground mb-2">{insights[i]["description"]}</div>
                                        <Link to="/ai/insights" className="text-xs text-primary font-semibold hover:underline">{insights[i]["action"] + " →"}</Link>
                                    </div>
                                    for i in range(min(3, len(insights)))]}
                                    <Link to="/ai/insights" className="btn btn-outline btn-sm w-full">
                                        {"View All Insights"}
                                    </Link>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        <div className="card">
                            <div className="p-5 border-b border-border flex items-center justify-between">
                                <h3 className="section-title mb-0">
                                    <Users size={16} className="text-red-500" />
                                    {"Urgent Requests Nearby"}
                                </h3>
                                <Link to="/requests" className="text-xs text-primary font-semibold hover:underline">{"View all"}</Link>
                            </div>
                            <div className="divide-y divide-border">
                                {len(urgent_requests) == 0 and
                                    <div className="p-8 text-center text-sm text-muted-foreground">{"No urgent requests right now"}</div>
                                }
                                {[<div key={urgent_requests[i]["id"]} className="p-4 flex items-start justify-between gap-3">
                                    <div>
                                        <div className="text-sm font-semibold text-foreground">{urgent_requests[i]["title"]}</div>
                                        <div className="text-xs text-muted-foreground mt-0.5">{str(urgent_requests[i]["people_count"]) + " people · " + urgent_requests[i]["location_text"]}</div>
                                    </div>
                                    <span className={"urgency-" + urgent_requests[i]["urgency"]}>{urgent_requests[i]["urgency"]}</span>
                                </div>
                                for i in range(min(4, len(urgent_requests)))]}
                            </div>
                        </div>

                        <div className="card">
                            <div className="p-5 border-b border-border">
                                <h3 className="section-title mb-0">
                                    <Calendar size={16} className="text-blue-500" />
                                    {"Quick Actions"}
                                </h3>
                            </div>
                            <div className="p-5 grid grid-cols-2 gap-3">
                                <Link to="/donations/new" className="card card-p flex flex-col items-center gap-2 text-center hover:border-amber-300 hover:bg-amber-50 cursor-pointer">
                                    <Package size={24} className="text-amber-500" />
                                    <span className="text-sm font-semibold text-foreground">{"Post Donation"}</span>
                                </Link>
                                <Link to="/events/new" className="card card-p flex flex-col items-center gap-2 text-center hover:border-blue-300 hover:bg-blue-50 cursor-pointer">
                                    <Calendar size={24} className="text-blue-500" />
                                    <span className="text-sm font-semibold text-foreground">{"Create Event"}</span>
                                </Link>
                                <Link to="/ai/insights" className="card card-p flex flex-col items-center gap-2 text-center hover:border-purple-300 hover:bg-purple-50 cursor-pointer">
                                    <Brain size={24} className="text-purple-500" />
                                    <span className="text-sm font-semibold text-foreground">{"AI Insights"}</span>
                                </Link>
                                <Link to="/map" className="card card-p flex flex-col items-center gap-2 text-center hover:border-green-300 hover:bg-green-50 cursor-pointer">
                                    <MapPin size={24} className="text-green-500" />
                                    <span className="text-sm font-semibold text-foreground">{"View Map"}</span>
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
