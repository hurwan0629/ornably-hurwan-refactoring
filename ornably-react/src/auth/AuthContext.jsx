import React, { useCallback, useEffect, useMemo, useState } from "react";
import { AuthContext } from "./authStore";
import ornablyAPI from "../lib/api";

export function AuthProvider({ children }) {
  const [status, setStatus] = useState("loading");
  const [user, setUser] = useState(null);

  const isAuthed = !!user?.authenticated;
  const role = user?.role ?? null;
  const authorities = useMemo(() => user?.authorities ?? [], [user]);

  const loadMe = useCallback(async () => {
    setStatus("loading");

    try {
      const res = await ornablyAPI.get("/all/auth/info");
      setUser(res.data);
    } catch {
      setUser(null);
    } finally {
      setStatus("ready");
    }
  }, []);

  useEffect(() => {
    loadMe();
  }, [loadMe]);

  useEffect(() => {
    const interceptorId = ornablyAPI.interceptors.response.use(
      (res) => res,
      async (err) => {
        const code = err?.response?.status;

        if (code === 401 || code === 403) {
          setUser(null);
          setStatus("ready");
        }

        return Promise.reject(err);
      }
    );

    return () => ornablyAPI.interceptors.response.eject(interceptorId);
  }, []);

  const value = useMemo(
    () => ({
      status,
      user,
      authorities,
      role,
      isAuthed,
      loadMe,
      setUser,
    }),
    [status, user, role, isAuthed, authorities, loadMe]
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}
