import from "@jac/runtime" { Link, jacIsLoggedIn }
import from "lucide-react" { Leaf, Map, Package, Users, Calendar, ArrowRight, Heart, Zap, Shield, TrendingUp }

def:pub LandingPage() -> JsxElement {
    logged_in: bool = jacIsLoggedIn();

    return (
        <div className="min-h-screen bg-white">
            <div className="navbar">
                <div className="navbar-inner">
                    <div className="navbar-logo">
                        <div className="navbar-logo-icon">
                            <Leaf size={16} color="white" strokeWidth={2.5} />
                        </div>
                        <span className="text-primary">{"Nourish"}</span>
                    </div>
                    <div className="hidden md:flex items-center gap-1">
                        <Link to="/map" className="nav-link">{"Map"}</Link>
                        <Link to="/donations/feed" className="nav-link">{"Donations"}</Link>
                        <Link to="/requests" className="nav-link">{"Requests"}</Link>
                        <Link to="/events" className="nav-link">{"Events"}</Link>
                    </div>
                    <div className="flex items-center gap-2">
                        {not logged_in and
                            <div className="flex items-center gap-2">
                                <Link to="/auth" className="btn btn-ghost btn-sm">{"Sign in"}</Link>
                                <Link to="/auth" className="btn btn-primary btn-sm">{"Get started"}</Link>
                            </div>
                        }
                        {logged_in and
                            <Link to="/dashboard/user" className="btn btn-primary btn-sm">{"Dashboard"}</Link>
                        }
                    </div>
                </div>
            </div>

            <div className="hero">
                <div className="hero-content">
                    <div className="inline-flex items-center gap-2 bg-white/10 text-white text-sm font-medium px-4 py-2 rounded-full mb-6 border border-white/20">
                        <Heart size={14} />
                        {"Fighting food waste. Feeding communities."}
                    </div>
                    <h1 className="hero-title">
                        {"Rescue Food."}
                        <br />
                        <span className="text-secondary">{"Feed People."}</span>
                    </h1>
                    <p className="hero-subtitle">
                        {"Nourish connects organizations with surplus food to shelters, food banks, and individuals in need. Real-time matching. Zero waste."}
                    </p>
                    <div className="flex flex-wrap justify-center gap-3">
                        <Link to="/map" className="btn btn-primary btn-lg flex items-center gap-2">
                            <Map size={18} />
                            {"Find Food Near You"}
                        </Link>
                        <Link to="/requests/new" className="btn btn-lg bg-white/10 text-white border-white/30 hover:bg-white/20 flex items-center gap-2">
                            {"Make a Request"}
                            <ArrowRight size={18} />
                        </Link>
                        <Link to="/auth" className="btn btn-secondary btn-lg flex items-center gap-2">
                            {"Donate Food"}
                        </Link>
                    </div>
                </div>
            </div>

            <div className="max-w-7xl mx-auto px-6 py-16">
                <div className="text-center mb-12">
                    <h2 className="text-3xl font-bold text-foreground mb-3">{"How Nourish Works"}</h2>
                    <p className="text-muted-foreground max-w-xl mx-auto">{"Three simple steps to connect surplus food with people who need it most."}</p>
                </div>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <div className="text-center">
                        <div className="w-16 h-16 bg-primary-light rounded-2xl flex items-center justify-center mx-auto mb-4">
                            <Package size={28} className="text-primary" />
                        </div>
                        <h3 className="text-lg font-bold text-foreground mb-2">{"1. Post Available Food"}</h3>
                        <p className="text-muted-foreground text-sm">{"Organizations post surplus food with details, quantity, and pickup window."}</p>
                    </div>
                    <div className="text-center">
                        <div className="w-16 h-16 bg-secondary-light rounded-2xl flex items-center justify-center mx-auto mb-4">
                            <Zap size={28} className="text-secondary" />
                        </div>
                        <h3 className="text-lg font-bold text-foreground mb-2">{"2. AI Matches Instantly"}</h3>
                        <p className="text-muted-foreground text-sm">{"Our AI dispatcher matches donations to nearby shelters and urgent requests in real time."}</p>
                    </div>
                    <div className="text-center">
                        <div className="w-16 h-16 bg-success-light rounded-2xl flex items-center justify-center mx-auto mb-4">
                            <Heart size={28} className="text-success" />
                        </div>
                        <h3 className="text-lg font-bold text-foreground mb-2">{"3. Food Reaches People"}</h3>
                        <p className="text-muted-foreground text-sm">{"Volunteers pick up and deliver. Families get fed. Food waste is eliminated."}</p>
                    </div>
                </div>
            </div>

            <div className="bg-muted py-16">
                <div className="max-w-7xl mx-auto px-6">
                    <div className="text-center mb-10">
                        <h2 className="text-3xl font-bold text-foreground mb-3">{"Our Impact"}</h2>
                    </div>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
                        <div className="text-center">
                            <div className="text-4xl font-extrabold text-primary mb-1">{"2,847"}</div>
                            <div className="text-sm text-muted-foreground">{"Meals Saved"}</div>
                        </div>
                        <div className="text-center">
                            <div className="text-4xl font-extrabold text-primary mb-1">{"1,203"}</div>
                            <div className="text-sm text-muted-foreground">{"People Helped"}</div>
                        </div>
                        <div className="text-center">
                            <div className="text-4xl font-extrabold text-primary mb-1">{"4.2t"}</div>
                            <div className="text-sm text-muted-foreground">{"Food Rescued"}</div>
                        </div>
                        <div className="text-center">
                            <div className="text-4xl font-extrabold text-primary mb-1">{"47"}</div>
                            <div className="text-sm text-muted-foreground">{"Partner Orgs"}</div>
                        </div>
                    </div>
                </div>
            </div>

            <div className="max-w-7xl mx-auto px-6 py-16">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div className="card card-p bg-gradient-to-br from-primary to-primary-dark text-white">
                        <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center mb-4">
                            <Users size={24} />
                        </div>
                        <h3 className="text-xl font-bold mb-2">{"I Need Food"}</h3>
                        <p className="text-white/80 text-sm mb-5">{"Browse available donations near you, create a food request, or find upcoming distribution events."}</p>
                        <Link to="/map" className="btn bg-white text-primary hover:bg-gray-100 border-white">
                            {"Find Food Near Me"}
                            <ArrowRight size={16} />
                        </Link>
                    </div>
                    <div className="card card-p bg-gradient-to-br from-secondary to-secondary-dark text-white">
                        <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center mb-4">
                            <Package size={24} />
                        </div>
                        <h3 className="text-xl font-bold mb-2">{"I Have Food to Donate"}</h3>
                        <p className="text-white/80 text-sm mb-5">{"Post surplus food, manage donations, view AI-powered insights, and track your community impact."}</p>
                        <Link to="/auth" className="btn bg-white text-secondary hover:bg-gray-100 border-white">
                            {"Start Donating"}
                            <ArrowRight size={16} />
                        </Link>
                    </div>
                </div>
            </div>

            <div className="bg-foreground text-white py-12">
                <div className="max-w-7xl mx-auto px-6 flex flex-col md:flex-row items-center justify-between gap-6">
                    <div>
                        <div className="flex items-center gap-2 mb-2">
                            <div className="navbar-logo-icon">
                                <Leaf size={14} color="white" />
                            </div>
                            <span className="font-bold text-lg">{"Nourish"}</span>
                        </div>
                        <p className="text-gray-400 text-sm">{"Connecting surplus food with communities in need."}</p>
                    </div>
                    <div className="flex gap-6 text-sm text-gray-400">
                        <Link to="/map" className="hover:text-white">{"Map"}</Link>
                        <Link to="/donations/feed" className="hover:text-white">{"Donations"}</Link>
                        <Link to="/requests" className="hover:text-white">{"Requests"}</Link>
                        <Link to="/events" className="hover:text-white">{"Events"}</Link>
                    </div>
                </div>
            </div>
        </div>
    );
}
