import from "@jac/runtime" { Navigate, jacIsLoggedIn, Link }
import from "lucide-react" {
    Brain, TrendingUp, AlertTriangle, MapPin, Zap,
    Package, Users, Clock, BarChart2, Target, RefreshCw
}
import from ..components.Navbar { Navbar }
import from ..components.Sidebar { Sidebar }
import from ..data.mockData { get_mock_ai_insights, get_mock_donations, get_mock_requests }

def:pub AIInsights() -> JsxElement {
    has insights: list[Any] = [];
    has donations: list[Any] = [];
    has requests: list[Any] = [];
    has refreshing: bool = False;

    if not jacIsLoggedIn() {
        return <Navigate to="/auth" replace={True} />;
    }

    async can with entry {
        insights = get_mock_ai_insights();
        donations = get_mock_donations();
        requests = get_mock_requests();
    }

    def handle_refresh(e: MouseEvent) -> None {
        refreshing = True;
        setTimeout(lambda -> None { refreshing = False; }, 1500);
    }

    expiring: list[Any] = [d for d in donations if d["status"] == "expiring_soon"];
    critical: list[Any] = [r for r in requests if r["urgency"] == "critical"];
    high_urg: list[Any] = [r for r in requests if r["urgency"] == "high"];

    demand_data: list[Any] = [
        {"zone": "East Village", "requests": 8, "donations": 2, "score": 85},
        {"zone": "Northside", "requests": 6, "donations": 1, "score": 78},
        {"zone": "Westside", "requests": 4, "donations": 5, "score": 32},
        {"zone": "Downtown", "requests": 3, "donations": 4, "score": 28},
        {"zone": "Midtown", "requests": 5, "donations": 3, "score": 55}
    ];

    food_demand: list[Any] = [
        {"category": "Prepared Meals", "demand": 92, "supply": 45},
        {"category": "Vegetables", "demand": 78, "supply": 60},
        {"category": "Dairy", "demand": 65, "supply": 40},
        {"category": "Bread", "demand": 58, "supply": 70},
        {"category": "Canned Goods", "demand": 45, "supply": 80}
    ];

    return (
        <div className="min-h-screen bg-background">
            <Navbar role={"org"} />
            <div className="dashboard-layout">
                <Sidebar role={"org"} />
                <div className="dashboard-content">
                    <div className="page-header flex items-center justify-between">
                        <div>
                            <h1 className="page-title flex items-center gap-2">
                                <Brain size={24} className="text-purple-500" />
                                {"AI Insights"}
                            </h1>
                            <p className="page-subtitle">{"Demand forecasting, urgency scoring, and smart recommendations."}</p>
                        </div>
                        <button className="btn flex items-center gap-2" onClick={handle_refresh} disabled={refreshing}>
                            <RefreshCw size={14} className={refreshing and "animate-spin" or ""} />
                            {"Refresh Analysis"}
                        </button>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                        <div className="card card-p bg-gradient-to-br from-red-50 to-red-100 border-red-200">
                            <div className="flex items-center gap-2 mb-2">
                                <AlertTriangle size={18} className="text-red-600" />
                                <span className="text-sm font-bold text-red-800">{"Critical Alerts"}</span>
                            </div>
                            <div className="text-3xl font-extrabold text-red-700">{str(len(critical))}</div>
                            <div className="text-xs text-red-600 mt-1">{"Immediate action required"}</div>
                        </div>
                        <div className="card card-p bg-gradient-to-br from-amber-50 to-amber-100 border-amber-200">
                            <div className="flex items-center gap-2 mb-2">
                                <Clock size={18} className="text-amber-600" />
                                <span className="text-sm font-bold text-amber-800">{"Expiring Soon"}</span>
                            </div>
                            <div className="text-3xl font-extrabold text-amber-700">{str(len(expiring))}</div>
                            <div className="text-xs text-amber-600 mt-1">{"Donations need redistribution"}</div>
                        </div>
                        <div className="card card-p bg-gradient-to-br from-purple-50 to-purple-100 border-purple-200">
                            <div className="flex items-center gap-2 mb-2">
                                <Target size={18} className="text-purple-600" />
                                <span className="text-sm font-bold text-purple-800">{"Match Score"}</span>
                            </div>
                            <div className="text-3xl font-extrabold text-purple-700">{"87%"}</div>
                            <div className="text-xs text-purple-600 mt-1">{"Donation-request alignment"}</div>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
                        <div className="card">
                            <div className="p-5 border-b border-border">
                                <h3 className="section-title mb-0">
                                    <TrendingUp size={16} className="text-blue-500" />
                                    {"Demand Hotspot Map"}
                                </h3>
                                <p className="text-xs text-muted-foreground mt-1">{"Areas with high request-to-donation ratio"}</p>
                            </div>
                            <div className="p-5">
                                <div className="flex flex-col gap-3">
                                    {[<div key={demand_data[i]["zone"]} className="flex items-center gap-3">
                                        <div className="w-24 text-xs font-semibold text-foreground flex-shrink-0">{demand_data[i]["zone"]}</div>
                                        <div className="flex-1">
                                            <div className="progress-bar">
                                                <div className="progress-fill" style={{"width": str(demand_data[i]["score"]) + "%", "background": "#DC2626" if demand_data[i]["score"] > 70 else ("#F59E0B" if demand_data[i]["score"] > 40 else "#16A34A")}} />
                                            </div>
                                        </div>
                                        <div className="text-xs text-muted-foreground w-20 flex-shrink-0">
                                            {str(demand_data[i]["requests"]) + "R / " + str(demand_data[i]["donations"]) + "D"}
                                        </div>
                                        <span className={"badge " + ("badge-red" if demand_data[i]["score"] > 70 else ("badge-amber" if demand_data[i]["score"] > 40 else "badge-green"))}>
                                            {str(demand_data[i]["score"])}
                                        </span>
                                    </div>
                                    for i in range(len(demand_data))]}
                                </div>
                                <div className="flex gap-4 mt-4 text-xs text-muted-foreground">
                                    <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-red-500" />{"High need"}</span>
                                    <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-amber-400" />{"Medium"}</span>
                                    <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-green-500" />{"Covered"}</span>
                                </div>
                            </div>
                        </div>

                        <div className="card">
                            <div className="p-5 border-b border-border">
                                <h3 className="section-title mb-0">
                                    <BarChart2 size={16} className="text-purple-500" />
                                    {"Food Category Demand vs Supply"}
                                </h3>
                                <p className="text-xs text-muted-foreground mt-1">{"Identify gaps in food availability"}</p>
                            </div>
                            <div className="p-5">
                                <div className="flex flex-col gap-4">
                                    {[<div key={food_demand[i]["category"]}>
                                        <div className="flex items-center justify-between mb-1">
                                            <span className="text-xs font-semibold text-foreground">{food_demand[i]["category"]}</span>
                                            <span className="text-xs text-muted-foreground">
                                                {"D:" + str(food_demand[i]["demand"]) + "% S:" + str(food_demand[i]["supply"]) + "%"}
                                            </span>
                                        </div>
                                        <div className="flex gap-1">
                                            <div className="flex-1">
                                                <div className="text-xs text-muted-foreground mb-0.5">{"Demand"}</div>
                                                <div className="progress-bar">
                                                    <div className="progress-fill" style={{"width": str(food_demand[i]["demand"]) + "%"}} />
                                                </div>
                                            </div>
                                            <div className="flex-1">
                                                <div className="text-xs text-muted-foreground mb-0.5">{"Supply"}</div>
                                                <div className="progress-bar">
                                                    <div className="progress-fill" style={{"width": str(food_demand[i]["supply"]) + "%", "background": "#16A34A"}} />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    for i in range(len(food_demand))]}
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="card mb-6">
                        <div className="p-5 border-b border-border">
                            <h3 className="section-title mb-0">
                                <Zap size={16} className="text-amber-500" />
                                {"Smart Recommendations"}
                            </h3>
                        </div>
                        <div className="p-5 grid grid-cols-1 md:grid-cols-2 gap-4">
                            {[<div key={str(i)} className={"insight-card border " + ("border-red-200 bg-red-50" if insights[i]["priority"] == "critical" else ("border-amber-200 bg-amber-50" if insights[i]["priority"] == "high" else "border-border"))}>
                                <div className="insight-card-header">
                                    <div className="flex items-center gap-2">
                                        <Brain size={14} className="text-purple-500" />
                                        <span className="insight-card-title">{insights[i]["title"]}</span>
                                    </div>
                                    <span className={"badge " + ("badge-red" if insights[i]["priority"] == "critical" else ("badge-amber" if insights[i]["priority"] == "high" else "badge-blue"))}>
                                        {insights[i]["priority"]}
                                    </span>
                                </div>
                                <p className="text-xs text-muted-foreground mb-3">{insights[i]["description"]}</p>
                                <button className="btn btn-sm btn-primary w-full">{insights[i]["action"]}</button>
                            </div>
                            for i in range(len(insights))]}
                        </div>
                    </div>

                    <div className="card">
                        <div className="p-5 border-b border-border">
                            <h3 className="section-title mb-0">
                                <AlertTriangle size={16} className="text-red-500" />
                                {"Urgency Scoring — Active Requests"}
                            </h3>
                        </div>
                        <div className="divide-y divide-border">
                            {[<div key={requests[i]["id"]} className="p-4 flex items-center justify-between gap-3">
                                <div className="flex-1 min-w-0">
                                    <div className="text-sm font-semibold text-foreground">{requests[i]["title"]}</div>
                                    <div className="text-xs text-muted-foreground">{requests[i]["location_text"]}</div>
                                </div>
                                <div className="flex items-center gap-3">
                                    <div className="text-right">
                                        <div className="text-xs text-muted-foreground">{"People"}</div>
                                        <div className="text-sm font-bold text-foreground">{str(requests[i]["people_count"])}</div>
                                    </div>
                                    <span className={"urgency-" + requests[i]["urgency"]}>{requests[i]["urgency"]}</span>
                                    <Link to={"/requests/" + requests[i]["id"]} className="btn btn-sm btn-outline">{"Respond"}</Link>
                                </div>
                            </div>
                            for i in range(len(requests))]}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
