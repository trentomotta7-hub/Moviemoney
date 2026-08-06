import { useAuth } from "@/_core/hooks/useAuth";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarHeader,
  SidebarInset,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarProvider,
  SidebarTrigger,
} from "@/components/ui/sidebar";
import { startLogin } from "@/const";
import { useIsMobile } from "@/hooks/useMobile";
import { ExternalLink, LogOut, Users } from "lucide-react";
import { useLocation } from "wouter";
import { DashboardLayoutSkeleton } from "./DashboardLayoutSkeleton";

const logo = "/manus-storage/logo_0fe6c467.png";
const menuItems = [
  { icon: Users, label: "Leads", path: "/admin" },
  { icon: ExternalLink, label: "Ver landing", path: "/" },
];

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  const { loading, user } = useAuth();

  if (loading) return <DashboardLayoutSkeleton />;
  if (!user) {
    return (
      <div className="mm-page flex min-h-screen items-center justify-center bg-background px-5 text-foreground">
        <div className="mm-machine-card w-full max-w-md p-8 text-center">
          <img src={logo} alt="Movie Money" className="mx-auto h-9 w-auto" />
          <h1 className="mt-8 text-3xl font-black uppercase text-white">Acesso administrativo</h1>
          <p className="mt-4 text-sm leading-7 text-zinc-500">Entre com a conta autorizada para consultar e exportar os leads.</p>
          <Button onClick={() => startLogin()} size="lg" className="mt-7 w-full rounded-none bg-cyan-300 font-mono text-xs uppercase tracking-[0.1em] text-black hover:bg-white">Entrar com segurança</Button>
        </div>
      </div>
    );
  }

  return (
    <SidebarProvider>
      <DashboardContent>{children}</DashboardContent>
    </SidebarProvider>
  );
}

function DashboardContent({ children }: { children: React.ReactNode }) {
  const { user, logout } = useAuth();
  const [location, setLocation] = useLocation();
  const isMobile = useIsMobile();

  return (
    <>
      <Sidebar collapsible="icon" className="border-r border-white/10">
        <SidebarHeader className="h-20 justify-center border-b border-white/10 px-4">
          <img src={logo} alt="Movie Money" className="h-7 w-auto object-contain group-data-[collapsible=icon]:hidden" />
          <span className="hidden font-mono text-[8px] uppercase tracking-[0.16em] text-cyan-300 group-data-[collapsible=icon]:block">MM</span>
        </SidebarHeader>
        <SidebarContent className="pt-4">
          <SidebarMenu className="px-2">
            {menuItems.map(item => (
              <SidebarMenuItem key={item.path}>
                <SidebarMenuButton isActive={location === item.path} onClick={() => setLocation(item.path)} tooltip={item.label} className="h-11 rounded-none font-mono text-[10px] uppercase tracking-[0.1em]">
                  <item.icon className="size-4" /><span>{item.label}</span>
                </SidebarMenuButton>
              </SidebarMenuItem>
            ))}
          </SidebarMenu>
        </SidebarContent>
        <SidebarFooter className="border-t border-white/10 p-3">
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <button className="flex w-full items-center gap-3 p-1 text-left outline-none focus-visible:ring-2 focus-visible:ring-cyan-300/50 group-data-[collapsible=icon]:justify-center">
                <Avatar className="size-9 shrink-0 border border-white/10"><AvatarFallback className="bg-cyan-300/10 text-xs text-cyan-300">{user?.name?.charAt(0).toUpperCase() || "A"}</AvatarFallback></Avatar>
                <div className="min-w-0 flex-1 group-data-[collapsible=icon]:hidden"><p className="truncate text-sm text-white">{user?.name || "Admin"}</p><p className="mt-1 truncate text-[10px] text-zinc-600">{user?.email || "Conta autorizada"}</p></div>
              </button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="w-48"><DropdownMenuItem onClick={logout} className="text-rose-400 focus:text-rose-400"><LogOut className="mr-2 size-4" /> Sair</DropdownMenuItem></DropdownMenuContent>
          </DropdownMenu>
        </SidebarFooter>
      </Sidebar>
      <SidebarInset className="bg-background">
        {isMobile && <div className="sticky top-0 z-40 flex h-14 items-center border-b border-white/10 bg-background/95 px-2 backdrop-blur"><SidebarTrigger className="size-9 rounded-none" /><span className="ml-2 font-mono text-[9px] uppercase tracking-[0.14em] text-zinc-500">Movie Money Admin</span></div>}
        <main className="min-h-screen flex-1">{children}</main>
      </SidebarInset>
    </>
  );
}
