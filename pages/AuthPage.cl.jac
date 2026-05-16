import from "@jac/runtime" { useNavigate, jacLogin, jacSignup, Link, jacIsLoggedIn }
import from "lucide-react" { Leaf, Building2, User, ArrowRight, Check }

def:pub AuthPage() -> JsxElement {
    has tab: str = "login";
    has role: str = "user";
    has username: str = "";
    has password: str = "";
    has confirm_pw: str = "";
    has error: str = "";
    has loading: bool = False;

    navigate = useNavigate();

    if jacIsLoggedIn() {
        navigate("/dashboard/user");
    }

    def set_tab_login(e: MouseEvent) -> None { tab = "login"; error = ""; }
    def set_tab_register(e: MouseEvent) -> None { tab = "register"; error = ""; }
    def set_role_user(e: MouseEvent) -> None { role = "user"; }
    def set_role_org(e: MouseEvent) -> None { role = "org"; }
    def handle_username(e: ChangeEvent) -> None { username = e.target.value; }
    def handle_password(e: ChangeEvent) -> None { password = e.target.value; }
    def handle_confirm(e: ChangeEvent) -> None { confirm_pw = e.target.value; }

    async def handle_submit(e: FormEvent) -> None {
        e.preventDefault();
        loading = True;
        error = "";
        ok: bool = False;
        signup_result: Any = None;
        try {
            if tab == "login" {
                ok = await jacLogin(username, password);
                if ok {
                    if role == "org" {
                        navigate("/dashboard/org");
                    } else {
                        navigate("/dashboard/user");
                    }
                } else {
                    error = "Invalid username or password.";
                }
            } else {
                if password != confirm_pw {
                    error = "Passwords do not match.";
                    loading = False;
                    return;
                }
                signup_result = await jacSignup(username, password);
                if signup_result {
                    ok = await jacLogin(username, password);
                    if ok {
                        navigate("/onboarding");
                    } else {
                        error = "Account created. Please sign in.";
                        tab = "login";
                    }
                } else {
                    error = "Username may already be taken.";
                }
            }
        } except Exception as ex {
            error = "Authentication error. Please try again.";
        }
        loading = False;
    }

    return (
        <div className="auth-page">
            <div className="auth-left">
                <div>
                    <div className="flex items-center gap-2 mb-8">
                        <div className="w-10 h-10 bg-white/20 rounded-xl flex items-center justify-center">
                            <Leaf size={20} color="white" />
                        </div>
                        <span className="text-2xl font-bold">{"Nourish"}</span>
                    </div>
                    <h2 className="text-3xl font-bold mb-4">{"Rescue food. Feed communities."}</h2>
                    <p className="text-white/70 text-base leading-relaxed">
                        {"Join thousands of organizations and individuals working together to eliminate food waste and fight hunger."}
                    </p>
                </div>
                <div className="flex flex-col gap-3">
                    <div className="flex items-center gap-3 text-white/80 text-sm">
                        <div className="w-6 h-6 bg-white/20 rounded-full flex items-center justify-center flex-shrink-0">
                            <Check size={12} />
                        </div>
                        {"Real-time food matching with AI"}
                    </div>
                    <div className="flex items-center gap-3 text-white/80 text-sm">
                        <div className="w-6 h-6 bg-white/20 rounded-full flex items-center justify-center flex-shrink-0">
                            <Check size={12} />
                        </div>
                        {"Live map of donations and requests"}
                    </div>
                    <div className="flex items-center gap-3 text-white/80 text-sm">
                        <div className="w-6 h-6 bg-white/20 rounded-full flex items-center justify-center flex-shrink-0">
                            <Check size={12} />
                        </div>
                        {"Impact tracking and analytics"}
                    </div>
                </div>
            </div>

            <div className="auth-right">
                <div className="auth-form-box">
                    <div className="mb-8">
                        <h1 className="text-2xl font-bold text-foreground mb-1">
                            {"Welcome back" if tab == "login" else "Create your account"}
                        </h1>
                        <p className="text-muted-foreground text-sm">
                            {"Sign in to your Nourish account" if tab == "login" else "Join the food rescue network"}
                        </p>
                    </div>

                    <div className="tabs mb-6">
                        <button className={"tab " + ("tab-active" if tab == "login" else "")} onClick={set_tab_login}>
                            {"Sign in"}
                        </button>
                        <button className={"tab " + ("tab-active" if tab == "register" else "")} onClick={set_tab_register}>
                            {"Create account"}
                        </button>
                    </div>

                    {tab == "register" and
                        <div className="mb-5">
                            <div className="label">{"I am a..."}</div>
                            <div className="grid grid-cols-2 gap-3">
                                <button
                                    className={"card card-p flex flex-col items-center gap-2 cursor-pointer border-2 " + ("border-primary bg-primary-light" if role == "user" else "border-border")}
                                    onClick={set_role_user}
                                >
                                    <User size={24} className={"text-primary" if role == "user" else "text-muted-foreground"} />
                                    <span className={"text-sm font-semibold " + ("text-primary" if role == "user" else "text-foreground")}>{"Individual"}</span>
                                    <span className="text-xs text-muted-foreground text-center">{"Find food, make requests"}</span>
                                </button>
                                <button
                                    className={"card card-p flex flex-col items-center gap-2 cursor-pointer border-2 " + ("border-primary bg-primary-light" if role == "org" else "border-border")}
                                    onClick={set_role_org}
                                >
                                    <Building2 size={24} className={"text-primary" if role == "org" else "text-muted-foreground"} />
                                    <span className={"text-sm font-semibold " + ("text-primary" if role == "org" else "text-foreground")}>{"Organization"}</span>
                                    <span className="text-xs text-muted-foreground text-center">{"Donate food, manage events"}</span>
                                </button>
                            </div>
                        </div>
                    }

                    <form onSubmit={handle_submit} className="flex flex-col gap-4">
                        <div className="form-group">
                            <label className="label">{"Username"}</label>
                            <input className="input" type="text" placeholder="Enter username" value={username} onChange={handle_username} required={True} />
                        </div>
                        <div className="form-group">
                            <label className="label">{"Password"}</label>
                            <input className="input" type="password" placeholder="Enter password" value={password} onChange={handle_password} required={True} />
                        </div>
                        {tab == "register" and
                            <div className="form-group">
                                <label className="label">{"Confirm Password"}</label>
                                <input className="input" type="password" placeholder="Confirm password" value={confirm_pw} onChange={handle_confirm} required={True} />
                            </div>
                        }
                        {error and <div className="error-box">{error}</div>}
                        <button className="btn btn-primary w-full" type="submit" disabled={loading}>
                            {loading and <span className="spinner" />}
                            {not loading and (("Sign in" if tab == "login" else "Create account"))}
                        </button>
                    </form>

                    <p className="text-center text-xs text-muted-foreground mt-6">
                        {"By continuing, you agree to Nourish's Terms of Service and Privacy Policy."}
                    </p>
                </div>
            </div>
        </div>
    );
}
